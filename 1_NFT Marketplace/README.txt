***************************************************************************************************************************
Steps for Test This Contract

->Deploy erc20.sol 
->now deploy NFT_Marketplace.sol and pass erc20 contract's address in Constructor argument.

->safeMint the NFT with 0.1 ether amount
->put it on Sell (nft id strat from 1) and amount of ERC20 token

->check viewonsale for see all NFT which is on sell .it shows nftID and its sell Price.

->select 2nd A/c for buy that NFT
->2nd address must have that ERC20 token.
->go to erc20.sol contract and approve the NFT_Marketplace's contract balance for spend some amount. 

->go to NFT owner A/c and approve nftId which is on sell. in approve address of NFT buyer/2nd address  amd nftId.
->now select 2nd Address for buy that NFT.

->in Buy button pass nftId which you want to buy, sell price of that NFT and counter(same as nftId).


Done you NFT transfer to buyer.
now select seller address and withdraw balance (sell price of NFT (ERC20 token)).

You can check viewonsale which show only onSale Nft's detail.

have any question? mail : mokaniakshit@gmail.com

***************************************************************************************************************************