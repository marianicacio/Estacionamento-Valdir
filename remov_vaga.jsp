<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    String vagaStr = request.getParameter("vaga");
    String mensagem = "";
    
    if (vagaStr != null) {
        try {
            int vagasARemover = Integer.parseInt(vagaStr);
            if (vagasARemover <= 0) {
                mensagem = "<p style='color:red; font-family: fantasy;'>Informe um número positivo de vagas para remover.</p>";
            } else {
                // Conectar no banco
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/estacionamento_administrador";
                String user = "root";
                String password = "";

                Connection conn = DriverManager.getConnection(url, user, password);

                // Buscar o número atual de vagas disponíveis
                String sqlSelect = "SELECT vagas_disponiveis FROM vagas LIMIT 1";
                PreparedStatement psSelect = conn.prepareStatement(sqlSelect);
                ResultSet rs = psSelect.executeQuery();

                if (rs.next()) {
                    int vagasAtuais = rs.getInt("vagas_disponiveis");

                    if (vagasARemover > vagasAtuais) {
                        mensagem = "<p style='color:red; font-family: fantasy;'>Não é possível remover mais vagas do que existem disponíveis (" + vagasAtuais + ").</p>";
                    } else {
                        int vagasNovas = vagasAtuais - vagasARemover;

                        // Atualizar o número de vagas disponíveis
                        String sqlUpdate = "UPDATE vagas SET vagas_disponiveis = ?";
                        PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                        psUpdate.setInt(1, vagasNovas);

                        int linhasAfetadas = psUpdate.executeUpdate();
                        if (linhasAfetadas > 0) {
                            mensagem = "<p style='color:green; font-family: fantasy;'>Sucesso! Vagas removidas. Vagas disponíveis agora: " + vagasNovas + ".</p>";
                        } else {
                            mensagem = "<p style='color:red; font-family: fantasy;'>Erro ao atualizar vagas.</p>";
                        }
                        psUpdate.close();
                    }
                } else {
                    mensagem = "<p style='color:red; font-family: fantasy;'>Erro: Não foi possível encontrar o registro de vagas.</p>";
                }

                rs.close();
                psSelect.close();
                conn.close();
            }
        } catch (NumberFormatException e) {
            mensagem = "<p style='color:red; font-family: fantasy;'>Por favor, insira um número válido.</p>";
        } catch (Exception e) {
            mensagem = "<p style='color:red; font-family: fantasy;'>Erro no banco de dados: " + e.getMessage() + "</p>";
        }
    } else {
        mensagem = "<p style='color:red; font-family: fantasy;'>Informe a quantidade de vagas a remover.</p>";
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Remover Vaga</title>
</head>
<body>
    <h1>Remover Vagas</h1>
    <%= mensagem %>
    <p><a href="remover_vaga.html">Voltar</a></p>
</body>
</html>
