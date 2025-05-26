<%-- 
    Document   : cadvaga
    Created on : 14 de mai. de 2025, 23:08:46
    Author     : João
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
     <%
    String vagaStr = request.getParameter("vaga");
    if (vagaStr == null || vagaStr.trim().isEmpty()) {
%>
        <p class="erro">Por favor, informe a quantidade de vagas a adicionar.</p>
<%
    } else {
        try {
            int vagasAdicionar = Integer.parseInt(vagaStr.trim());

            if (vagasAdicionar <= 0) {
%>
                <p class="erro">Informe um número positivo para vagas.</p>
<%
            } else {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/estacionamento_administrador";
                String user = "root";
                String password = "";

                Connection conn = DriverManager.getConnection(url, user, password);

                // Primeiro, buscar o valor atual de vagas_disponiveis
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT vagas_disponiveis FROM vagas LIMIT 1");

                int vagasAtuais = 0;
                if (rs.next()) {
                    vagasAtuais = rs.getInt("vagas_disponiveis");
                }

                rs.close();
                stmt.close();

                int vagasNovas = vagasAtuais + vagasAdicionar;

                // Atualizar o valor de vagas_disponiveis na tabela
                PreparedStatement ps = conn.prepareStatement("UPDATE vagas SET vagas_disponiveis = ?");
                ps.setInt(1, vagasNovas);

                int linhasAfetadas = ps.executeUpdate();

                if (linhasAfetadas > 0) {
%>
                    <p class="sucesso">Vagas atualizadas com sucesso! Total de vagas agora: <strong><%= vagasNovas %></strong>.</p>
<%
                } else {
%>
                    <p class="erro">Erro ao atualizar as vagas.</p>
<%
                }

                ps.close();
                conn.close();
            }
        } catch (NumberFormatException e) {
%>
            <p class="erro">Digite um número válido para as vagas.</p>
<%
        } catch (Exception e) {
%>
            <p class="erro">Erro: <%= e.getMessage() %></p>
<%
        }
    }
%>

</body>
</html>