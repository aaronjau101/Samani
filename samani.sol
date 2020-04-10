pragma solidity >=0.5.0 <0.6.0;

/**
* @title ERC721
* @dev ERC721 token standard
*/

contract ERC721 {
  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

  function balanceOf(address _owner) external view returns (uint256);
  function ownerOf(uint256 _tokenId) external view returns (address);
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
  function approve(address _approved, uint256 _tokenId) external payable;
}

/**
* @title Ownable
* @dev The Ownable contract has an owner address, and provides basic authorization control
* functions, this simplifies the implementation of "user permissions".
*/

contract Ownable {
  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
  * @dev The Ownable constructor sets the original `owner` of the contract to the sender
  * account.
  */
  constructor() internal {
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), _owner);
  }

  /**
  * @return the address of the owner.
  */
  function owner() public view returns(address) {
    return _owner;
  }

  /**
  * @dev Throws if called by any account other than the owner.
  */
  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  /**
  * @return true if `msg.sender` is the owner of the contract.
  */
  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }

  /**
  * @dev Allows the current owner to relinquish control of the contract.
  * @notice Renouncing to ownership will leave the contract without an owner.
  * It will not be possible to call the functions with the `onlyOwner`
  * modifier anymore.
  */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
  * @dev Allows the current owner to transfer control of the contract to a newOwner.
  * @param newOwner The address to transfer ownership to.
  */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
  * @dev Transfers control of the contract to a newOwner.
  * @param newOwner The address to transfer ownership to.
  */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title SafeMath32
 * @dev SafeMath library implemented for uint32
 */

library SafeMath32 {

  function mul(uint32 a, uint32 b) internal pure returns (uint32) {
    if (a == 0) {
      return 0;
    }
    uint32 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint32 a, uint32 b) internal pure returns (uint32) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint32 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint32 a, uint32 b) internal pure returns (uint32) {
    assert(b <= a);
    return a - b;
  }

  function add(uint32 a, uint32 b) internal pure returns (uint32) {
    uint32 c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title SafeMath16
 * @dev SafeMath library implemented for uint16
 */

library SafeMath16 {

  function mul(uint16 a, uint16 b) internal pure returns (uint16) {
    if (a == 0) {
      return 0;
    }
    uint16 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint16 a, uint16 b) internal pure returns (uint16) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint16 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint16 a, uint16 b) internal pure returns (uint16) {
    assert(b <= a);
    return a - b;
  }

  function add(uint16 a, uint16 b) internal pure returns (uint16) {
    uint16 c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title Samani Factory
 * @dev Make a Samani (with purchase) to create a random dna string used to make an animation
 */

contract SamaniFactory is Ownable {

	using SafeMath for uint256;
	using SafeMath32 for uint32;
	using SafeMath16 for uint16;

	event NewSamani(uint SamaniId, string name, uint dna);

	uint dnaDigits = 16;
	uint dnaModulus = 10 ** dnaDigits;
	uint SamaniFee = 0.001 ether;

	struct Samani {
		string name;
		uint dna;
	}

	Samani[] public Samanis;

	mapping (uint => address) public SamaniToOwner;
	mapping (address => uint) ownerSamaniCount;

	function _createSamani(string memory _name, uint _dna) internal {
		uint id = Samanis.push(Samani(_name, _dna)) - 1;
		SamaniToOwner[id] = msg.sender;
		ownerSamaniCount[msg.sender] = ownerSamaniCount[msg.sender].add(1);
		emit NewSamani(id, _name, _dna);
	}

	function _generateRandomDna(string memory _str) private view returns (uint) {
		uint rand = uint(keccak256(abi.encodePacked(_str)));
		return rand % dnaModulus;
	}

	function createRandomSamani(string memory _name) public payable {
		require(msg.value == SamaniFee);
		uint randDna = _generateRandomDna(_name);
		randDna = randDna - randDna % 100;
		_createSamani(_name, randDna);
	}

	function setSamaniFee(uint _fee) external onlyOwner {
		SamaniFee = _fee;
	}

	function withdraw() external onlyOwner {
		address _owner = owner();
		address(uint160(_owner)).transfer(address(this).balance);
	}

	function getSamanisByOwner(address _owner) external view returns(uint[] memory) {
		uint[] memory result = new uint[](ownerSamaniCount[_owner]);
		uint counter = 0;
		for (uint i = 0; i < Samanis.length; i++) {
			if (SamaniToOwner[i] == _owner) {
				result[counter] = i;
				counter++;
			}
		}
		return result;
	}
}

/**
 * @title Samani Ownership
 * @dev Contract used for trading Samanis between users
 */

contract SamaniOwnership is SamaniFactory, ERC721 {

	using SafeMath for uint256;

	mapping (uint => address) SamaniApprovals;

	modifier onlyOwnerOf(uint _SamaniId) {
		require(msg.sender == SamaniToOwner[_SamaniId]);
		_;
	}

	function balanceOf(address _owner) external view returns (uint256) {
		return ownerSamaniCount[_owner];
	}

	function ownerOf(uint256 _tokenId) external view returns (address) {
		return SamaniToOwner[_tokenId];
	}

	function _transfer(address _from, address _to, uint256 _tokenId) private {
		ownerSamaniCount[_to] = ownerSamaniCount[_to].add(1);
		ownerSamaniCount[msg.sender] = ownerSamaniCount[msg.sender].sub(1);
		SamaniToOwner[_tokenId] = _to;
		emit Transfer(_from, _to, _tokenId);
	}

	function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
		require (SamaniToOwner[_tokenId] == msg.sender || SamaniApprovals[_tokenId] == msg.sender);
		_transfer(_from, _to, _tokenId);
	}

	function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
		SamaniApprovals[_tokenId] = _approved;
		emit Approval(msg.sender, _approved, _tokenId);
	}
}