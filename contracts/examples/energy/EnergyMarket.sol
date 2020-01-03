pragma solidity ^0.5.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
// import "@hq20/contracts/contracts/access/Whitelist.sol";
import "./../../access/Whitelist.sol";


/**
 * @title Energy Market
 * @notice Implements a simple energy market, using ERC20 and Whitelist.
 * ERC20 is used to enable payments from the consumers to the distribution
 * network, represented by this contract, and from the distribution network
 * to the producers. Whitelist is used to keep a list of compliant smart
 * meters that communicate the production and consumption of energy.
 */
contract EnergyMarket is ERC20, Whitelist {
    using SafeMath for uint256;

    event EnergyProduced(address producer);
    event EnergyConsumed(address consumer);

    uint256 public load;
    uint256 public maxPrice;

    /**
     * @dev The constructor initializes the underlying currency token and the
     * smart meter whitelist. The constructor also mints the requested amount
     * of the underlying currency token to fund the network load. Also sets the
     * maximum energy price, used for calculating prices and for when load is 0
     * for production (supplying the first energy unit) or when load is 1 for
     * consumption (taking the last energy unit).
     */
    constructor (uint256 _initialSupply, uint256 _maxPrice)
        public
        ERC20()
        Whitelist()
    {
        _mint(address(this), _initialSupply);
        maxPrice = _maxPrice;
    }

    /**
     * @dev The production price is maxPrice / load + 1
     */
    function getProductionPrice() public view returns(uint256) {
        return maxPrice.div(load.add(1));
    }

    /**
     * @dev The consumption price is maxPrice / load
     */
    function getConsumptionPrice() public view returns(uint256) {
        if (load > 0) return maxPrice.div(load);
        else return maxPrice;
    }

    /**
     * @dev Add one energy unit to the distribution network and be paid the
     * production price. Only whitelisted smart meters can call this function.
     */
    function produce() public {
        require(isMember(msg.sender), "Unknown meter.");
        this.transfer(msg.sender, getProductionPrice());
        load = load.add(1);
        emit EnergyProduced(msg.sender);
    }

    /**
     * @dev Take one energy unit from the distribution network by paying the
     * consumption price. Only whitelisted smart meters can call this function.
     */
    function consume() public {
        require(isMember(msg.sender), "Unknown meter.");
        this.transferFrom(msg.sender, address(this), getConsumptionPrice());
        load = load.sub(1);
        emit EnergyConsumed(msg.sender);
    }
}