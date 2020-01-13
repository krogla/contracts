pragma solidity ^0.5.10;
import "../../exchange/UniswapExchange.sol";


contract TestUniswapExchange is UniswapExchange {

    constructor(address _tokenAddress) UniswapExchange(_tokenAddress) public {}

    function testEthToToken(
        address buyer,
        address recipient,
        uint256 ethIn,
        uint256 minTokensOut
    )
        public
        exchangeInitialized
    {
        ethToToken(
            buyer,
            recipient,
            ethIn,
            minTokensOut
        );
    }

    function testTokenToEth(
        address buyer,
        address payable recipient,
        uint256 tokensIn,
        uint256 minEthOut
    )
        public
        exchangeInitialized
    {
        tokenToEth(
            buyer,
            recipient,
            tokensIn,
            minEthOut
        );
    }

    function testTokenToTokenOut(
        address tokenPurchased,
        address buyer,
        address recipient,
        uint256 tokensIn,
        uint256 minTokensOut
    )
        public
        exchangeInitialized
    {
        tokenToTokenOut(
            tokenPurchased,
            buyer,
            recipient,
            tokensIn,
            minTokensOut
        );
    }
}
