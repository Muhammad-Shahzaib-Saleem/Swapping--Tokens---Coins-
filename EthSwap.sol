pragma solidity >=0.8.0;

import './Token.sol';
import "@openzeppelin/contracts/math/SafeMath.sol";

contract EthSwap {
    string public name = "EthSwap instant exchange";
    Token public token;
    uint public rate = 100; //redepmtion rate: # of Argentum tokens to receive for 1 ether
    using SafeMath for uint256;

    constructor (Token _token) public {
        token = _token;
    }

    event TokensPurchased (address indexed _from, address indexed _token, uint256 _value, uint _rate);
    event TokensSold (address indexed _from, address indexed _token, uint256 _value, uint _rate);
    event buyFailure(address indexed _from, uint256 _value);

    function buyTokens () public payable {
        uint tokenAmount = rate.mul(msg.value) ; 
        
        //require that EthSwap exchange has enough tokens to proceed with swap
        require(token.balanceOf(address(this)) >= tokenAmount);
        
        //transfer tokens to investor
        bool result = token.transfer(msg.sender, tokenAmount);
        if (result){
            emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);
        }
        else{
            emit buyFailure(msg.sender, tokenAmount);
        }

    }

    function sellTokens(uint _amount) public {
        require(token.balanceOf(msg.sender) >= _amount);
        uint etherAmount = _amount.div(rate);
        require (address(this).balance >= etherAmount);
        token.transferFrom(msg.sender , address(this),  _amount);
        payable(msg.sender).transfer(etherAmount);
        emit TokensSold (msg.sender, address(token), _amount, rate);
    }

}






pragma solidity ^0.5.0;

//Erc 20 test token

contract TestToken {
    string  public name = "TestToken";
    string  public symbol = "Tst";
    uint256 public totalSupply = 1000000000000000000000000; // 1 million tokens
    uint8   public decimals = 18;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() public {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}






