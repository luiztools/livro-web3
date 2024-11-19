//6.1
interface ERC721 {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

//6.2
contract MyNFTCollection is ERC721 {

//6.3
mapping(address => uint) private _balanceOf; //owner => number of tokens

function balanceOf(address owner) external view returns (uint) {
    return _balanceOf[owner];
}

//6.4
mapping(uint => address) private _ownerOf; //tokenId => owner

function ownerOf(uint id) external view returns (address) {
    address owner = _ownerOf[id];
    require(owner != address(0), "token does not exists");
    return owner;
}

//6.5
mapping(uint => address) private _approvals; //tokenId => operator
mapping(address => mapping(address => bool)) public isApprovedForAll; //owner => (operator => isApprovedForAll)

function _isApprovedOrOwner(
    address owner,
    address spender,
    uint id
) private view returns (bool) {
    return (spender == owner ||
        isApprovedForAll[owner][spender] ||
        spender == _approvals[id]);
}

//6.6
function _transferFrom(address from, address to, uint id) private {
    require(from == _ownerOf[id], "from is not owner");
    require(to != address(0), "transfer to zero address");

    require(_isApprovedOrOwner(from, msg.sender, id), "not authorized");

    _balanceOf[from]--;
    _balanceOf[to]++;
    _ownerOf[id] = to;

    delete _approvals[id];

    emit Transfer(from, to, id);
    emit Approval(from, address(0), id);
}

//6.7
function transferFrom(address from, address to, uint id) external payable {
   _transferFrom(from, to, id);
}

//6.8
interface ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
}

//6.9
function safeTransferFrom(address from, address to, uint id) external payable {
    _transferFrom(from, to, id);

    require(
        to.code.length == 0 ||
            ERC721TokenReceiver(to).onERC721Received(
                msg.sender,
                from,
                id,
                ""
            ) ==
            ERC721TokenReceiver.onERC721Received.selector,
        "unsafe recipient"
    );
}

//6.10
function safeTransferFrom(address from, address to, uint id, bytes calldata data) external payable {
    _transferFrom(from, to, id);

    require(
        to.code.length == 0 ||
            ERC721TokenReceiver(to).onERC721Received(
                msg.sender,
                from,
                id,
                data
            ) ==
            ERC721TokenReceiver.onERC721Received.selector,
        "unsafe recipient"
    );
}

//6.11
function setApprovalForAll(address operator, bool approved) external {
    isApprovedForAll[msg.sender][operator] = approved;
    emit ApprovalForAll(msg.sender, operator, approved);
}

//6.12
function approve(address spender, uint id) external payable {
    address owner = _ownerOf[id];
    require(
        msg.sender == owner || isApprovedForAll[owner][msg.sender],
        "not authorized"
    );

    _approvals[id] = spender;

    emit Approval(owner, spender, id);
}

//6.13
function getApproved(uint id) external view returns (address) {
    require(_ownerOf[id] != address(0), "token does not exists");
    return _approvals[id];
}

//6.14
interface ERC165 {
   function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

//6.15
contract MyNFTCollection is ERC721, ERC165 {
   function supportsInterface(
       bytes4 interfaceId
   ) external pure returns (bool) {
       return
           interfaceId == 0x80ac58cd || //ERC721
           interfaceId == 0x01ffc9a7; //ERC165
   }

//6.16
uint private _lastId = 0;

function mint() public payable {
    require(msg.value >= 0.001 ether, "Insufficient payment");
    _lastId++;
    _balanceOf[msg.sender]++;
    _ownerOf[_lastId] = msg.sender;
    
    emit Transfer(address(0), msg.sender, _lastId);
}

//6.17
interface ERC721Metadata {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 _tokenId) external view returns (string memory);
}

contract MyNFTCollection is ERC721, ERC165, ERC721Metadata {

//6.18
{
    "name": "Minha NFT 001",
    "description": "A simple image of my collection",
    "image": "https://www.luiztools.com.br/cara.jpg"
}

//6.19
{
   "name": "Shiba 001",
   "description": "Shiba sleeping.",
   "tokenId": 1,
   "image": "ipfs://QmdApGm9H3HLiUm3YWMCafkVqVwmuXE5Y8V3DqjMyk8nqF/1.jpg"
}

//6.20
contract MyNFTCollection is ERC721, ERC165, ERC721Metadata {

    string constant private _name = "My NFT Collection";

    function name() external view returns (string memory){
        return _name;
    }

    string constant private _symbol = "MNC";

    function symbol() external view returns (string memory){
        return _symbol;
    }

//6.21
import "@openzeppelin/contracts/utils/Strings.sol";

//6.22
function tokenURI(uint256 _tokenId) external view returns (string memory){
    string memory id = string(abi.encode(_tokenId));
    return string.concat("ipfs://QmboN71a5h7R3GDPp9GQJXSqdrHE2ohUttKaKbD34ga4Dm/", id, ".json");
}

//6.23
function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
    return
        interfaceId == 0x80ac58cd || //ERC721
        interfaceId == 0x01ffc9a7 || //ERC165
        interfaceId == 0x5b5e139f; //ERC721Metadata 
}

//6.24
contract MyNFTCollection is ERC721, ERC165, ERC721Metadata {

    address immutable private _owner;

    constructor(){
        _owner = msg.sender;
    }

    function withdraw() public {
        require(msg.sender == _owner, "Invalid withdraw");
        payable(_owner).transfer(address(this).balance);
    }