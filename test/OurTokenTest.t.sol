// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract OurTokenTest is StdCheats, Test {
    uint256 STARTING_BALANCE = 100 ether;

    OurToken public ourToken;
    DeployOurToken public deployer;
    address public deployerAddress;
   
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }
    function testInitialSupply() public {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testTransfer() public {
        vm.prank(bob);
        ourToken.transfer(alice, 100); // Transfer 100 tokens to Alice
        assertEq(ourToken.balanceOf(alice), 100);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - 100, "Bob's balance should decrease by 100");
    }

    function testTransferFrom() public {
        vm.prank(bob);
        uint256 amount = 100;
        ourToken.approve(alice, amount);

        // Alice transfers tokens on behalf of the Bob
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, amount);

        assertEq(ourToken.balanceOf(alice), amount, "Alice's balance should be 100 after transfer");
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - amount, "Bob's balance should decrease by 100");

        vm.expectRevert();
        (bool revertsAsExpected) = ourToken.transferFrom(bob, alice, amount);
        assertTrue(!revertsAsExpected, "expectRevert: call did not revert as it should");
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

}