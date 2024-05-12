import 'package:web3dart/web3dart.dart';

class TES {
  String name = "Token de Margem de 6 Meses";
  String symbol = "TES";
  BigInt annualInterestRate = BigInt.from(90); // 0.9% expresso em pontos-base
  BigInt secondsInYear = BigInt.from(31536000); // Número de segundos em um ano
  BigInt totalSupply = BigInt.zero;
  BigInt releaseDate = BigInt.zero; // Data de liberação dos fundos
  EthereumAddress contractAddress;
  Web3Client client;

  TES(this.client, this.contractAddress);

  Future<BigInt> deposit(BigInt amount) async {
    EthereumAddress from = await client.credentials.extractAddress();
    final function = ContractFunction(
      'deposit',
      [],
      [BigIntType()],
    );
    final response = await client.sendTransaction(
      Transaction.callContract(
        contract: DeployedContract(
          ContractAbi.fromJson(abi, 'TES'),
          contractAddress,
        ),
        function: function,
        parameters: [amount],
        from: from,
      ),
    );
    return response;
  }

  Future<BigInt> withdraw(BigInt amount) async {
    EthereumAddress from = await client.credentials.extractAddress();
    final function = ContractFunction(
      'withdraw',
      [],
      [BigIntType()],
    );
    final response = await client.sendTransaction(
      Transaction.callContract(
        contract: DeployedContract(
          ContractAbi.fromJson(abi, 'TES'),
          contractAddress,
        ),
        function: function,
        parameters: [amount],
        from: from,
      ),
    );
    return response;
  }

  Future<BigInt> getBalance(EthereumAddress account) async {
    final function = ContractFunction(
      'balanceOf',
      [],
      [AddressType()],
    );
    final response = await client.call(
      contract: DeployedContract(
        ContractAbi.fromJson(abi, 'TES'),
        contractAddress,
      ),
      function: function,
      params: [account],
    );
    return response.single as BigInt;
  }

  Future<BigInt> getTokenBalance(EthereumAddress account) async {
    final function = ContractFunction(
      'tokenBalanceOf',
      [],
      [AddressType()],
    );
    final response = await client.call(
      contract: DeployedContract(
        ContractAbi.fromJson(abi, 'TES'),
        contractAddress,
      ),
      function: function,
      params: [account],
    );
    return response.single as BigInt;
  }

  static final List<dynamic> abi = [
    // Aqui vai a ABI do contrato TES
  ];
}
