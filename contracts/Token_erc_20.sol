// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns(uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
    require(b <= a, "SafeMath: substraction overflow");
    uint256 c = a - b;

    return c;
    }
    
    function mul(uint256 a, uint256 b) internal pure returns(uint256) {
    if (a == 0) {
        return 0;
    }  
    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
    }

    function div(uint256 a, uint256 b) internal pure returns(uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");     
        uint256 c = a / b;
        // assert(a == b * c + a % b) // There is no case in which this doesn't hold     
        return c;   
    }

    function mod(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b != 0, "SafeMath: modulo by zero");

        return a / b;
    }
}
// new emission only owner
contract Ownable {

address private _owner;

event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

constructor ()  {
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), _owner);
}

function renounceOwnership() public virtual onlyOwner { 
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
}

function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
}

function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
}
modifier onlyOwner() {
        require(_owner == address(0), "Ownable: caller is not the owner"); 
        _;
    }
}

contract MySecondToken is Ownable {

using SafeMath for uint;

string public constant name = "MySecondToken";
string public constant symbol = "MST";
uint8 public constant decimals = 18; // 10^18 wei 

uint public totalSupply; 

mapping (address => uint) balances; // массив адресов 
mapping (address => mapping(address => uint)) allowed; 
// для методов transfer и approve 
event Transfer (address indexed _from, address indexed _to, uint _value);
event Approval (address indexed _from, address indexed _to, uint _value);

// выпуск новых токенов 
function mint(address to, uint value) onlyOwner public {
    balances[to] = balances[to].add(value); // добавляем к балансу 
    totalSupply = totalSupply.add(value);   // увеличиваем тоталсаплай
}

// баланс указанного адресса 
function balanceOf(address owner) public view returns(uint) {
    return balances[owner];
}

// позволяет снимать кол-во токенов разрешено снимать какому то адрессу 
function allowance(address _owner, address _spender) public view returns(uint)  {
    return allowed[_owner][_spender];
}

// отправка токенов с основного адресса msg.sender
function transfer(address _to, uint _value) public {
    require(balances[msg.sender] >= _value); // делаем проверку что на балансе отправителя есть указанная в переводе сумма
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);    
}

// отпрака с указанного адреса 
function transferFrom(address _from, address _to, uint _value) public {
    require(balances[_from] >= _value  && allowed[_from][msg.sender] >= _value); 
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);  
    emit Transfer(_from, _to, _value);
}

// позволяет снимать токены с указанного адреса 
function approve(address _spender, uint _value) public {
    allowed[msg.sender][_spender] = _value; 
    emit Approval(msg.sender, _spender, _value);
}

}

// without library

// contract MySecondToken {

// string public constant name = "MySecondToken";
// string public constant symbol = "MST";
// uint8 public constant decimals = 2;

// uint public totalSupply;

// mapping (address => uint) balances;
// mapping (address => mapping(address => uint)) allowed;

// event Transfer (address indexed _from, address indexed _to, uint _value);
// event Approval (address indexed _from, address indexed _to, uint _value);

// function mint(address to, uint value) public {
//     require(totalSupply + value >= totalSupply && balances[to] + value >= balances[to]);
//     balances[to] += value;
//     totalSupply +=value;   
// }

// function balanceOf(address owner) public view returns(uint) {
//     return balances[owner];
// }

// function allowance(address _owner, address _spender) public view returns(uint)  {
//     return allowed[_owner][_spender];
// }

// function transfer(address _to, uint _value) public {
//     require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
//     balances[msg.sender] -= _value;
//     balances[_to] += _value;
//     emit Transfer(msg.sender, _to, _value);    
// }

// function transferFrom(address _from, address _to, uint _value) public {
//     require(balances[_from] >= _value && balances[_to] + _value >= balances[_to] && allowed[_from][msg.sender] >= _value);
//     balances[_from] -= _value;
//     balances[_to] += _value;
//     allowed[_from][msg.sender] -=_value;
//     emit Transfer(_from, _to, _value);
// }

// function approve(address _spender, uint _value) public {
//     allowed[msg.sender][_spender] = _value;
//     emit Approval(msg.sender, _spender, _value);
// }

// }