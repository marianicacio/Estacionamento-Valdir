<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // Pega os parâmetros do formulário
    String precoBaseStr = request.getParameter("preco_base");
    String precoAdicionalStr = request.getParameter("preco_adicional");

    // Busca na sessão os valores atuais ou inicializa padrão
    Double precoBase = (Double) session.getAttribute("precoBase");
    Double precoHoraAdicional = (Double) session.getAttribute("precoHoraAdicional");

    if (precoBase == null) precoBase = 25.0;
    if (precoHoraAdicional == null) precoHoraAdicional = 9.0;

    String mensagem = "";

    if (precoBaseStr != null && precoAdicionalStr != null) {
        try {
            precoBase = Double.parseDouble(precoBaseStr);
            precoHoraAdicional = Double.parseDouble(precoAdicionalStr);

            // Salva na sessão
            session.setAttribute("precoBase", precoBase);
            session.setAttribute("precoHoraAdicional", precoHoraAdicional);

            mensagem = "✅ Preços alterados com sucesso!";
        } catch (NumberFormatException e) {
            mensagem = "❌ Valores inválidos, use números válidos.";
        }
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Processar Preços</title>
</head>
<body>
    <h1>Configuração de Preços</h1>

    <p><%= mensagem %></p>

    <p>Preço Base Atual: R$ <%= String.format("%.2f", precoBase) %></p>
    <p>Preço por Hora Adicional Atual: R$ <%= String.format("%.2f", precoHoraAdicional) %></p>

    <p><a href="alterar_precos.html">Alterar preços novamente</a></p>
</body>
</html>
