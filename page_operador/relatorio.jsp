<%@page import="java.sql.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Relatório Financeiro</title>
    <link rel="stylesheet" href="../operador_css/operador.css">
    <style>
        html, body {
            margin: 0;
            padding: 0;
            overflow-x: auto;
        }
        .resumo {
            margin: 20px;
            padding: 20px;
            background-color: #f3f3f3;
            border-radius: 10px;
            width: 60%;
            font-size: 18px;
        }
    </style>
</head>
<body>

<h1 style="font-family: fantasy">📊 Relatório Financeiro</h1>

<div class="resumo">
<%
    String inicioStr = request.getParameter("periodo_começo");
    String fimStr = request.getParameter("periodo_final");

    if (inicioStr != null && fimStr != null) {
        try {
            // Conexão com o banco
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/estacionamento_administrador", "root", "root");

            // Convertendo para Timestamp para pegar o dia inteiro
            Timestamp inicio = Timestamp.valueOf(inicioStr + " 00:00:00");
            Timestamp fim = Timestamp.valueOf(fimStr + " 23:59:59");

            // Total de entradas
            PreparedStatement entradas = conn.prepareStatement("SELECT COUNT(*) FROM carro WHERE hora_entrada BETWEEN ? AND ?");
            entradas.setTimestamp(1, inicio);
            entradas.setTimestamp(2, fim);
            ResultSet rsEntradas = entradas.executeQuery();
            rsEntradas.next();
            int totalEntradas = rsEntradas.getInt(1);

            // Total de saídas
            PreparedStatement saidas = conn.prepareStatement("SELECT COUNT(*) FROM carro WHERE hora_saida BETWEEN ? AND ?");
            saidas.setTimestamp(1, inicio);
            saidas.setTimestamp(2, fim);
            ResultSet rsSaidas = saidas.executeQuery();
            rsSaidas.next();
            int totalSaidas = rsSaidas.getInt(1);

            // Total faturado
            PreparedStatement faturamento = conn.prepareStatement("SELECT SUM(valor_pago) FROM carro WHERE hora_saida BETWEEN ? AND ?");
            faturamento.setTimestamp(1, inicio);
            faturamento.setTimestamp(2, fim);
            ResultSet rsFaturamento = faturamento.executeQuery();
            rsFaturamento.next();
            double totalFaturado = rsFaturamento.getDouble(1);

            // Formata data para exibir bonitinho
            SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");

%>
    <p><strong>Período:</strong> <%= formato.format(java.sql.Date.valueOf(inicioStr)) %> até <%= formato.format(java.sql.Date.valueOf(fimStr)) %></p>
    <p><strong>🔑 Total de Entradas:</strong> <%= totalEntradas %> carros</p>
    <p><strong>🚗 Total de Saídas:</strong> <%= totalSaidas %> carros</p>
    <p><strong>💰 Total Faturado:</strong> R$ <%= String.format("%.2f", totalFaturado) %></p>

<%
            // Fechando conexões
            rsEntradas.close();
            rsSaidas.close();
            rsFaturamento.close();
            entradas.close();
            saidas.close();
            faturamento.close();
            conn.close();

        } catch (Exception e) {
            out.println("<p style='color:red;'>Erro ao gerar relatório: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p style='color:blue;'>Preencha as datas para gerar o relatório.</p>");
    }
%>
</div>

</body>
</html>
