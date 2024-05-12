import java.util.HashMap;
import java.util.Map;

public class LoginSecurityKernel {
    private static final Map<String, Integer> loggedInUsers = new HashMap<>();
    private static final int MAX_PARTICIPANTS_PER_UNIT = 7;
    private static final int MAX_UNITS = 300;

    public static boolean login(String username, String password) {
        // Lógica de autenticação
        boolean isAuthenticated = authenticateUser(username, password);

        // Se autenticado com sucesso, registra o usuário logado
        if (isAuthenticated) {
            loggedInUsers.put(username, loggedInUsers.getOrDefault(username, 0) + 1);
        }

        return isAuthenticated;
    }

    public static boolean logout(String username) {
        // Remove o usuário da lista de usuários logados ao fazer logout
        if (loggedInUsers.containsKey(username)) {
            loggedInUsers.put(username, loggedInUsers.get(username) - 1);
            if (loggedInUsers.get(username) == 0) {
                loggedInUsers.remove(username);
            }
            return true;
        }
        return false;
    }

    public static boolean isTokenClosed() {
        // Verifica se o número de unidades ativas é menor ou igual a 300
        return loggedInUsers.size() <= MAX_UNITS;
    }public class Main {
    public static void main(String[] args) {
        // Simulação de login e controle de acesso
        String username = "user123";
        String password = "password123";

        if (LoginSecurityKernel.login(username, password)) {
            System.out.println("Login successful");
            if (LoginSecurityKernel.canJoinUnit(username)) {
                System.out.println("User can join unit");
            } else {
                System.out.println("Unit is full");
            }
        } else {
            System.out.println("Login failed");
        }

        // Simulação de logout
        LoginSecurityKernel.logout(username);

        // Verifica se o token está fechado
        if (LoginSecurityKernel.isTokenClosed()) {
            System.out.println("Token is closed");
        } else {
            System.out.println("Token is still open");
        }
    }
}

    public static boolean canJoinUnit(String username) {
        // Verifica se o número de participantes na unidade atual é menor que 7
        return loggedInUsers.getOrDefault(username, 0) < MAX_PARTICIPANTS_PER_UNIT;
    }

    private static boolean authenticateUser(String username, String password) {
        // Lógica de autenticação - a ser implementada de acordo com requisitos específicos
        return true; // Simulação de autenticação bem-sucedida
    }
}
