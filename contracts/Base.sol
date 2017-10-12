pragma solidity ^0.4.11;

contract Object {
    uint constant OK = 1;
    uint constant UNAUTHORISED = 0;
    uint constant FAILED = 2;
}

contract FeaturedAdapter is Object {
    uint constant FEATURE_IS_UNAVAILABE = 42;

    event FeeTaken(address indexed sender, bytes4 sig, uint amount);

    modifier featured(uint[1] memory _result) {
        if (!isAvailable(msg.sender, msg.sig)) {
            assembly {
                mstore(0, 42) // FEATURE_IS_UNAVAILABE
                return(0, 32)
            }
        }

        _;

        if (_result[0] == OK) {
            if(takeFee(msg.sender, msg.sig) != OK) revert();
        }
    }

    function isAvailable(address sender, bytes4 sig) private returns (bool) {
        // TODO: implement
    }

    function takeFee(address sender, bytes4 sig) private returns (uint) {
        // TODO: implement

        FeeTaken(sender, sig, 0);
        return OK;
    }
}

contract Tester is FeaturedAdapter {
    bool available;

    function testSuccess()  returns (uint) {
        return _testSuccess([uint(0)]);
    }

    function _testSuccess(uint[1] memory _result) private featured(_result) returns (uint) {
        _result[0] = OK;
        return _result[0];
    }

    function testFailure() returns (uint) {
        return _testFailure([uint(0)]);
    }

    function _testFailure(uint[1] memory _result) private featured(_result) returns (uint) {
        _result[0] = FAILED;
        return _result[uint(0)];
    }

    function testUnauthorised() returns (uint) {
        return _testUnauthorised([uint(0)]);
    }

    function _testUnauthorised(uint[1] memory _result) private featured(_result) returns (uint) {
        _result[0] = UNAUTHORISED;
        return _result[uint(0)];
    }

    function setAvailable(bool _available) {
        available = _available;
    }

    function isAvailable(address sender, bytes4 sig) private returns (bool) {
        return true;
    }
}
