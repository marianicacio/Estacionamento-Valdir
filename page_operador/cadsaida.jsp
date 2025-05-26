<%@page import="java.sql.*"%>
<%@page import="java.time.*"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Saída de Carros</title>
</head>
<body>
<%
    String placa = request.getParameter("placa");
    String data_saida = request.getParameter("data_saida");   // Ex: 2025-05-05
    String hora_saida = request.getParameter("hora_saida");   // Ex: 17:40
    String forma_pagamento = request.getParameter("pagamento");

    if (placa != null && data_saida != null && hora_saida != null && forma_pagamento != null) {
        placa = placa.toUpperCase().trim();

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/estacionamento_administrador", "root", "root");

            // Buscar hora_entrada do carro
            PreparedStatement psBusca = conn.prepareStatement("SELECT hora_entrada FROM carro WHERE placa = ? AND hora_saida IS NULL");
            psBusca.setString(1, placa);
            ResultSet rs = psBusca.executeQuery();

            if (rs.next()) {
                Timestamp entradaTS = rs.getTimestamp("hora_entrada");
                LocalDateTime entrada = entradaTS.toLocalDateTime();

                // Converte os parâmetros de data e hora de saída para LocalDateTime
                String dataHoraSaidaStr = data_saida + "T" + hora_saida;
                LocalDateTime saida = LocalDateTime.parse(dataHoraSaidaStr);

                // Verifica se a saída é antes da entrada
                if (saida.isBefore(entrada)) {
                    out.print("<p style='color:red;'>❌ Erro: A data/hora de saída não pode ser anterior à entrada.</p>");
                    return;
                }

                Timestamp saidaTimestamp = Timestamp.valueOf(saida);

                // Calcula os minutos totais entre a entrada e a saída
                long minutos = ChronoUnit.MINUTES.between(entrada, saida);

                // Converte minutos em horas e minutos restantes
                long horas = minutos / 60;
                long minutosRestantes = minutos % 60;

                // Cálculo do preço
                double preco_total = 25.0; // Primeira hora

                if (horas > 1) {
                    preco_total += (horas - 1) * 9.0;
                }

                if (minutosRestantes > 0) {
                    preco_total += 9.0; // Nova hora pelo tempo fracionado
                }

                // Buscar ID da forma de pagamento
                PreparedStatement psPag = conn.prepareStatement("SELECT id FROM pagamento WHERE forma_pagamento = ?");
                psPag.setString(1, forma_pagamento);
                ResultSet rsPag = psPag.executeQuery();

                if (rsPag.next()) {
                    int pagamentoId = rsPag.getInt("id");

                    // Atualiza o carro com os dados de saída
                    PreparedStatement psUpdate = conn.prepareStatement(
                        "UPDATE carro SET data_saida = ?, hora_saida = ?, valor_pago = ?, forma_pagamento = ? WHERE placa = ?"
                    );
                    psUpdate.setTimestamp(1, saidaTimestamp); // data_saida
                    psUpdate.setTimestamp(2, saidaTimestamp); // hora_saida
                    psUpdate.setDouble(3, preco_total);
                    psUpdate.setInt(4, pagamentoId);
                    psUpdate.setString(5, placa);

                    int atualizado = psUpdate.executeUpdate();

                    if (atualizado > 0) {
                        // Libera uma vaga
                        PreparedStatement psVaga = conn.prepareStatement("UPDATE vagas SET vagas_disponiveis = vagas_disponiveis + 1 WHERE id = 1");
                        psVaga.executeUpdate();
                        psVaga.close();
                        horas = horas + 1; // corrige o numero de horas, pois a primeira não foi considerada 
                        out.println("<h3>✅ Saída registrada com sucesso.</h3>");
                        out.println("<p><strong>Data de Entrada:</strong> " + entrada + "</p>");
                        out.println("<p><strong>Data de Saída:</strong> " + saida + "</p>");
                        out.println("<p><strong>Minutos entre entrada e saída:</strong> " + minutos + "</p>");
                        out.println("<p><strong>Horas calculadas:</strong> " + horas + "</p>");
                        out.println("<p><strong>Preço Total:</strong> R$ " + String.format("%.2f", preco_total) + "</p>");
                    } else {
                        out.print("<p style='color:red;'>❌ Erro ao registrar saída.</p>");
                    }

                    psUpdate.close();
                } else {
                    out.print("<p style='color:red;'>❌ Forma de pagamento inválida.</p>");
                }

                rsPag.close();
                psPag.close();
            } else {
                out.print("<p style='color:red;'>❌ Carro não encontrado ou já saiu.</p>");
            }

            rs.close();
            psBusca.close();
            conn.close();
        } catch (Exception e) {
            out.print("<p style='color:red;'>❌ Erro: " + e.getMessage() + "</p>");
        }
    } else {
        out.print("<p style='color:blue;'>Preencha todos os campos.</p>");
    }
%>
</body>
</html>
