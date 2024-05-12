Aqui está uma tradução do código Java fornecido para Dart:

```dart
import 'dart:typed_data';
import 'package:bignum/bignum.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/pointycastle.dart';

class KeyPair {
  final SECPPrivateKey privateKey;
  final SECPPublicKey publicKey;

  KeyPair(this.privateKey, this.publicKey);

  static KeyPair create(SECPPrivateKey privateKey, ECCurve_secp256k1 curve) {
    return KeyPair(privateKey, SECPPublicKey(privateKey.Q, curve));
  }

  static Future<KeyPair> generate(String algorithm) async {
    final keyPairGenerator = KeyGenerator('EC');
    final keyGenParams = ECCurve_secp256k1();
    final keyParams = ECKeyGeneratorParameters(keyGenParams);
    keyPairGenerator.init(ParametersWithRandom(keyParams));
    final rawKeyPair = await keyPairGenerator.generateKeyPair();
    final privateKey = rawKeyPair.privateKey as ECPrivateKey;
    final publicKey = rawKeyPair.publicKey as ECPublicKey;
    final privateKeyValue = privateKey.d!;
    final publicKeyValue = publicKey.Q!.x!.toBigInteger();
    return KeyPair(
      SECPPrivateKey(privateKeyValue, algorithm),
      SECPPublicKey(publicKeyValue, algorithm),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeyPair &&
        this.privateKey == other.privateKey &&
        this.publicKey == other.publicKey;
  }

  @override
  int get hashCode => privateKey.hashCode ^ publicKey.hashCode;

  @override
  String toString() {
    return 'KeyPair{privateKey: $privateKey, publicKey: $publicKey}';
  }
}
```

Nesta tradução, utilizei a biblioteca `pointycastle` para trabalhar com criptografia de curva elíptica e gerar pares de chaves. A função `generate` agora retorna um objeto `Future<KeyPair>`, pois a geração de chaves é assíncrona. Eu também modifiquei alguns tipos de dados e métodos para corresponder à sintaxe e semântica do Dart.
Aqui está a tradução do código Java fornecido para Dart:

```dart
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/src/utils.dart' as utils;
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';

class NodeKey {
  final SecurityModule securityModule;
  final SignatureAlgorithm signatureAlgorithm = SignatureAlgorithmFactory.getInstance();

  NodeKey(this.securityModule);

  SECPSignature sign(Uint8List dataHash) {
    final Signature signature = securityModule.sign(Bytes32(dataHash));
    final r = utils.decodeBigInt(signature.r, endian: Endian.big);
    final s = utils.decodeBigInt(signature.s, endian: Endian.big);
    return signatureAlgorithm.normaliseSignature(r, s, getPublicKey(), dataHash);
  }

  SECPPublicKey getPublicKey() {
    return signatureAlgorithm.createPublicKey(ECPointUtil.getEncodedBytes(securityModule.getPublicKey().Q.getEncoded(false)));
  }

  Uint8List calculateECDHKeyAgreement(SECPPublicKey partyKey) {
    final curve = ECCurve_secp256k1();
    final ecdh = ECDH();
    ecdh.init(
      PublicKeyParameter(ECPublicKey(partyKey.Q, curve)),
      PrivateKeyParameter(ECPrivateKey(securityModule.getPrivateKey().d, curve)),
    );
    return ecdh.calculateAgreement(
      PublicKeyParameter(ECPublicKey(partyKey.Q, curve)),
      PrivateKeyParameter(ECPrivateKey(securityModule.getPrivateKey().d, curve)),
    );
  }
}
```

Nesta tradução, utilizei a biblioteca `pointycastle` para trabalhar com criptografia de curva elíptica e assinaturas digitais ECDSA. Também implementei a geração da chave de acordo de chave ECDH.
Aqui está a tradução do código Java fornecido para Dart:

```dart
import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/src/utils.dart' as utils;

class SECPPrivateKey implements PrivateKey {
  final Uint8List encoded;
  final String algorithm;

  SECPPrivateKey(this.encoded, this.algorithm);

  factory SECPPrivateKey.create(BigInt key, String algorithm) {
    return SECPPrivateKey(
      utils.encodeBigInt(key),
      algorithm,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SECPPrivateKey && encoded == other.encoded && algorithm == other.algorithm;
  }

  @override
  Uint8List getEncoded() {
    return encoded;
  }

  Bytes32 getEncodedBytes() {
    return Bytes32(encoded);
  }

  BigInt getD() {
    return utils.decodeBigInt(encoded);
  }

  @override
  String getAlgorithm() {
    return algorithm;
  }

  @override
  String getFormat() {
    return null;
  }

  @override
  int get hashCode {
    return encoded.hashCode;
  }

  @override
  String toString() {
    return encoded.toString();
  }
}
```

Nesta tradução, implementei a interface `PrivateKey` do `pointycastle` e as funcionalidades necessárias para criar uma chave privada ECDSA.
Aqui está a tradução do código Java fornecido para Dart, com a função `decode` adicionada e a conversão de parâmetros para parâmetros opcionais:

```dart
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/src/utils.dart' as utils;
import 'package:pointycastle/ecc/api.dart';

class SECPSignature {
  static const int BYTES_REQUIRED = 65;

  final int recId;
  final BigInt r;
  final BigInt s;

  SECPSignature({
    @required this.r,
    @required this.s,
    @required this.recId,
  });

  factory SECPSignature.decode(Uint8List bytes, BigInt curveOrder) {
    if (bytes.length != BYTES_REQUIRED) {
      throw ArgumentError(
          'Encoded SECP256K1 signature must be 65 bytes long');
    }

    final r = utils.decodeBigInt(bytes.sublist(0, 32));
    final s = utils.decodeBigInt(bytes.sublist(32, 64));
    final recId = bytes[64];
    return SECPSignature(r: r, s: s, recId: recId);
  }

  Uint8List encodedBytes() {
    final bytes = Uint8List(BYTES_REQUIRED);
    utils.encodeBigInt(r).copyRange(bytes, 0);
    utils.encodeBigInt(s).copyRange(bytes, 32);
    bytes[64] = recId;
    return bytes;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SECPSignature &&
        this.r == other.r &&
        this.s == other.s &&
        this.recId == other.recId;
  }

  @override
  int get hashCode => r.hashCode ^ s.hashCode ^ recId.hashCode;

  @override
  String toString() {
    return 'Signature{r: $r, s: $s, recId: $recId}';
  }
}
```

Com esta tradução, agora você pode criar uma instância de `SECPSignature` usando a função `decode` e os parâmetros opcionais.
Aqui está uma tradução para Dart do utilitário `KeyPairUtil` fornecido:

```dart
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:pointycastle/ecc/api.dart';

class KeyPairUtil {
  static final SignatureAlgorithm signatureAlgorithm = SignatureAlgorithmFactory.getInstance();

  static String loadResourceFile(String resourcePath) {
    try {
      final file = File(resourcePath);
      return file.readAsStringSync().trim();
    } catch (e) {
      throw Exception('Unable to load resource: $resourcePath');
    }
  }

  static KeyPair loadKeyPairFromResource(String resourcePath) {
    final String keyData = loadResourceFile(resourcePath);
    if (keyData == null || keyData.isEmpty) {
      throw ArgumentError('Unable to load resource: $resourcePath');
    }
    final SECPPrivateKey privateKey = signatureAlgorithm.createPrivateKey(Bytes32.fromHexString(keyData));
    final KeyPair keyPair = signatureAlgorithm.createKeyPair(privateKey);
    print('Loaded keyPair ${keyPair.getPublicKey().toString()} from $resourcePath');
    return keyPair;
  }

  static KeyPair loadKeyPair(File keyFile) {
    KeyPair key;
    if (keyFile.existsSync()) {
      key = load(keyFile);
      print('Loaded public key ${key.getPublicKey().toString()} from ${keyFile.path}');
    } else {
      key = signatureAlgorithm.generateKeyPair();
      storeKeyFile(key, keyFile.parent);
      print('Generated new ${signatureAlgorithm.getCurveName()} public key ${key.getPublicKey().toString()} and stored it to ${keyFile.path}');
    }
    return key;
  }

  static KeyPair loadKeyPairFromDirectory(Directory directory) {
    return loadKeyPair(File('${directory.path}/key'));
  }

  static void storeKeyFile(KeyPair keyPair, Directory homeDirectory) {
    storeKeyPair(keyPair, File('${homeDirectory.path}/key'));
  }

  static KeyPair load(File file) {
    return signatureAlgorithm.createKeyPair(loadPrivateKey(file));
  }

  static SECPPrivateKey loadPrivateKey(File file) {
    try {
      final List<String> info = file.readAsLinesSync();
      if (info.length != 1) {
        throw Exception('Supplied file does not contain valid key pair.');
      }
      return signatureAlgorithm.createPrivateKey(Bytes32.fromHexString(info[0]));
    } catch (e) {
      throw Exception('Supplied file does not contain valid key pair.');
    }
  }

  static void storeKeyPair(KeyPair keyPair, File file) {
    final File privateKeyDir = file.parent;
    privateKeyDir.createSync(recursive: true);
    final tempFile = File('${privateKeyDir.path}/temp.tmp');
    tempFile.writeAsStringSync(keyPair.getPrivateKey().getEncodedBytes().toString());
    tempFile.renameSync(file.path);
  }
}
```

Com esta tradução, você pode usar os métodos fornecidos para carregar ou armazenar chaves de um arquivo ou recurso.