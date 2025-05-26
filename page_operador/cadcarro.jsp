<%@page import="java.sql.*" %>
<%@page import="java.time.*" %>
<%@page import="java.time.format.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Cadastro de carros</title>
</head>
<body>

<%

String placa = request.getParameter("placa");
String data_entrada = request.getParameter("data_entrada");
String hora_entrada = request.getParameter("hora_entrada");
boolean placaValida = false;
boolean dataValida = true;

if (placa != null) {
    placa = placa.toUpperCase().trim();
    if (placa.length() == 7 && 
       (placa.matches("[A-Z]{3}[0-9]{4}") || placa.matches("[A-Z]{3}[0-9]{1}[A-Z]{1}[0-9]{2}"))) {
        placaValida = true;
    } else {
        out.print("<p style='color: red;'>❌ Erro: Placa inválida.</p>");
    }
}

if (data_entrada != null && hora_entrada != null && placaValida) {
    try {
        LocalDate dataAtual = LocalDate.now();
        LocalDate dataEntrada = LocalDate.parse(data_entrada);
        

        if (!dataEntrada.equals(dataAtual)) {
            out.print("<p style='color:red;'>Erro: A data de entrada deve ser o dia de hoje.</p>");
            dataValida = false;
        }
    } catch (Exception e) {
        out.print("<p style='color:red;'>Erro de data: " + e.getMessage() + "</p>");
        dataValida = false;
    }
} else {
    dataValida = false;
}

int vagasDisponiveis = 0;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/estacionamento_administrador", "root", "root");

    PreparedStatement psVagas = conn.prepareStatement("SELECT vagas_disponiveis FROM vagas WHERE id = 1");
    ResultSet rs = psVagas.executeQuery();
    if (rs.next()) {
        vagasDisponiveis = rs.getInt("vagas_disponiveis");
    }
    rs.close();
    psVagas.close();

    if ("POST".equalsIgnoreCase(request.getMethod()) && placaValida && dataValida) {
        // Junta data e hora como timestamp
        String dataHoraEntradaStr = data_entrada + "T" + hora_entrada;
        Timestamp entrada = Timestamp.valueOf(LocalDateTime.parse(dataHoraEntradaStr));

        PreparedStatement ps = conn.prepareStatement("INSERT INTO carro (placa, data_entrada, hora_entrada) VALUES (?, ?, ?)");
        ps.setString(1, placa);
        ps.setTimestamp(2, entrada);
        ps.setTimestamp(3, entrada);

        int resultado = ps.executeUpdate();

        if (resultado > 0) {
            PreparedStatement psUpdate = conn.prepareStatement("UPDATE vagas SET vagas_disponiveis = vagas_disponiveis - 1 WHERE id = 1 AND vagas_disponiveis > 0");
            psUpdate.executeUpdate();
            psUpdate.close();
            
            
            out.print("<p>✅ Carro cadastrado com sucesso!</p>");
        } else {
            out.print("<p style='color:red;'>❌ Erro ao cadastrar.</p>");
        }
        ps.close();
    }

    conn.close();
} catch (Exception e) {
    out.print("<p style='color:red;'>Erro: " + e.getMessage() + "</p>");
}

%>
</body>
</html>
