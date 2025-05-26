<%@page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Atualizar Vagas</title>
</head>
<body>
<%
    String vagaParam = request.getParameter("vaga");

    if (vagaParam != null && !vagaParam.trim().isEmpty()) {
        try {
            int vagasAdicionar = Integer.parseInt(vagaParam.trim());

            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/estacionamento_administrador";
            String user = "root";
            String password = "root";

            Connection conn = DriverManager.getConnection(url, user, password);

            // Busca quantidade atual de vagas
            String selectSql = "SELECT vagas_disponiveis FROM vagas WHERE id = 1";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(selectSql);

            int vagasAtuais = 0;
            if (rs.next()) {
                vagasAtuais = rs.getInt("vagas_disponiveis");
            }
            rs.close();

            int novoTotal = vagasAtuais + vagasAdicionar;

            // Atualiza total de vagas
            String updateSql = "UPDATE vagas SET vagas_disponiveis = ? WHERE id = 1";
            PreparedStatement ps = conn.prepareStatement(updateSql);
            ps.setInt(1, novoTotal);

            int linhas = ps.executeUpdate();
            if (linhas > 0) {
                out.print("<p style='color:green; font-family: fantasy;'>✅ Vagas atualizadas com sucesso! Total agora: " + novoTotal + "</p>");
            } else {
                out.print("<p style='color:red;'>❌ Erro ao atualizar as vagas.</p>");
            }

            ps.close();
            conn.close();

        } catch (NumberFormatException e) {
            out.print("<p style='color:red;'>❌ Valor inválido. Insira um número.</p>");
        } catch (Exception e) {
            out.print("<p style='color:red;'>Erro: " + e.getMessage() + "</p>");
        }
    } else {
        out.print("<p style='color:red;'>Por favor, insira a quantidade de vagas.</p>");
    }
%>
</body>
</html>
