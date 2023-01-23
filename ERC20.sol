// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.11;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address spender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );
}

contract ERC20 is IERC20 {
    address payable owner;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    string public name;
    string public symbol;
    uint256 public decimals = 18;

    constructor() {
        owner = payable(msg.sender);
        name = "udoka";
        symbol = "UDTK";
    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address spender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        allowance[spender][msg.sender] -= amount;
        balanceOf[spender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(spender, recipient, amount);
        return true;
    }

    function mint(uint256 amount) external onlyOwner {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint256 amount) external onlyOwner {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }
}
