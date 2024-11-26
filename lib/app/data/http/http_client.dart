import 'dart:convert';  // Para utilizar jsonEncode para converter Map em JSON
import 'package:http/http.dart' as http;

// Define uma interface para o cliente HTTP que abstrai os métodos HTTP usados na aplicação
abstract class IHttpClient {
  // Método para realizar requisições GET
  Future get({required String url});
  
  // Método para realizar requisições POST
  Future<http.Response> post({required String url, Map<String, dynamic>? body});
  
  // Método para realizar requisições PUT (Adicionado para manipular dados existentes)
  Future<http.Response> put({required String url, Map<String, dynamic>? body});
}

// Implementação concreta da interface IHttpClient usando o pacote http
class HttpClient implements IHttpClient {
  // Criação de uma instância do cliente HTTP
  final client = http.Client();

  // Implementação do método GET
  @override
  Future get({required String url}) async {
    // Realiza uma requisição GET para a URL especificada
    return await client.get(Uri.parse(url));
  }

  // Implementação do método POST
  @override
  Future<http.Response> post({required String url, Map<String, dynamic>? body}) async {
    try {
      // Realiza uma requisição POST para a URL especificada
      final response = await client.post(
        Uri.parse(url), // Converte a string para URI
        headers: {'Content-Type': 'application/json'}, // Define o cabeçalho da requisição
        body: body != null ? jsonEncode(body) : null, // Converte o corpo para JSON, se existir
      );
      return response; // Retorna a resposta da requisição
    } catch (e) {
      // Lança uma exceção caso ocorra um erro na requisição
      throw Exception('Erro ao fazer requisição POST: $e');
    }
  }

  // Implementação do método PUT
  @override
  Future<http.Response> put({required String url, Map<String, dynamic>? body}) async {
    try {
      // Realiza uma requisição PUT para a URL especificada
      final response = await client.put(
        Uri.parse(url), // Converte a string para URI
        headers: {'Content-Type': 'application/json'}, // Define o cabeçalho da requisição
        body: body != null ? jsonEncode(body) : null, // Converte o corpo para JSON, se existir
      );
      return response; // Retorna a resposta da requisição
    } catch (e) {
      // Lança uma exceção caso ocorra um erro na requisição
      throw Exception('Erro ao fazer requisição PUT: $e');
    }
  }
}
