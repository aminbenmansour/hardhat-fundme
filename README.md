# hardhat-fundme

* `--network` flag to deploy to a specific chain instead of the default one, hardhat. for example rinkeby.
```
yarn hardhat deploy --network rinkeby
```

* `--tags` flag to deploy to a specific tags only. Here we will be only deploying mocks.
```
yarn hardhat deploy --tags mocks
```

* run a cluster of nodes and deploying all contracts at once

```
yarn hardhat node
```