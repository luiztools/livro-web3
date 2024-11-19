# hello-solidity-hardhat
Projeto de contrato utilizando HardHat, capítulo 9.

## Como Executar

Pré-requisito: Node.js, disponível em https://nodejs.org

1. git clone 
2. cd hello-solidity-hardhat
3. npm install
4. npx hardhat test

## Como fazer Deploy

Pré-requisito: nó Sepolia na Infura, disponível em https://infura.io

1. realize os passos acima de execução
2. copie o arquivo .env.example como .env
3. preencha o arquivo .env
4. npm run deploy

## Como verificar

Pré-requisito: API Key da EtherScan, disponível em https://etherscan.io/myapikey

1. realize os passos acima de deploy
2. preencha a API Key no arquivo .env
4. npx hardhat verify --network sepolia <contrato>

## Mais

Para adquirir o livro, visite: https://www.luiztools.com.br/livro-web3

Para conhecer o meu curso online, visite: https://www.luiztools.com.br/curso-web23

Me siga também nas redes sociais: https://about.me/luiztools

Receba novidades no Telegram: https://t.me/luiznews
