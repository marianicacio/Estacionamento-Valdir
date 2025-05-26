<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Remover Funcionário</title>
    <meta charset="UTF-8">
    <style>
        body { font-family: fantasy; }
        .mensagem { margin-top: 20px; }
        .sucesso { color: green; }
        .erro { color: red; }
    </style>
</head>
<body>

<%
    String email = request.getParameter("email");
    if (email == null || email.trim().isEmpty()) {
%>
        <p class="erro">Por favor, informe um e-mail válido para exclusão.</p>
<%
    } else {
        email = email.trim();

        Connection conn = null;
        PreparedStatement psCheck = null;
        PreparedStatement psDelete = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/estacionamento_administrador";
            String user = "root";
            String password = "";

            conn = DriverManager.getConnection(url, user, password);

            // Verificar se usuário existe e se NÃO é admin
            String sqlCheck = "SELECT tipo_usuario FROM usuario WHERE email = ?";
            psCheck = conn.prepareStatement(sqlCheck);
            psCheck.setString(1, email);
            rs = psCheck.executeQuery();

            if (rs.next()) {
                String tipoUsuario = rs.getString("tipo_usuario");
                if ("admin".equalsIgnoreCase(tipoUsuario)) {
%>
                    <p class="erro">Não é permitido excluir um usuário administrador.</p>
<%
                } else {
                    // Deleta o usuário
                    String sqlDelete = "DELETE FROM usuario WHERE email = ?";
                    psDelete = conn.prepareStatement(sqlDelete);
                    psDelete.setString(1, email);
                    int linhasAfetadas = psDelete.executeUpdate();

                    if (linhasAfetadas > 0) {
%>
                        <p class="sucesso">Usuário com e-mail <strong><%= email %></strong> excluído com sucesso.</p>
<%
                    } else {
%>
                        <p class="erro">Erro ao excluir o usuário.</p>
<%
                    }
                }
            } else {
%>
                <p class="erro">Usuário com o e-mail <strong><%= email %></strong> não encontrado.</p>
<%
            }

        } catch (Exception e) {
%>
            <p class="erro">Erro: <%= e.getMessage() %></p>
<%
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(psCheck != null) psCheck.close(); } catch(Exception e) {}
            try { if(psDelete != null) psDelete.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }
%>

</body>
</html>
