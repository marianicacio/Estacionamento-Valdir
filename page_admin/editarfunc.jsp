<%@page import="java.sql.*" %>
<%@page import="java.time.*" %>
<%@page import="java.time.format.*" %>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            // recebe os dados alterados no formulario carregaprod.jsp
            String email,senha, cargo;
            
            String emailAntigo = request.getParameter("emailAntigo");
            
            
            email = request.getParameter("email");
            senha = request.getParameter("senha");
            cargo = request.getParameter("cargo");
            Connection conecta;
            PreparedStatement st;
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url="jdbc:mysql://localhost:3306/estacionamento_administrador";
            String user="root";
            String password="root";
            //alterar os dados na tabela produto no BDados
            conecta = DriverManager.getConnection(url,user,password);
            String sql = ("UPDATE usuario SET email = ?, senha = ?, cargo = ?  WHERE email = ?");
            st=conecta.prepareStatement(sql);
            
            st.setString(1,email);
            st.setString(2,senha);
            st.setString(3,cargo);
            st.setString(4,emailAntigo);
            
            st.executeUpdate();
            out.print("Os dados do usuario " + emailAntigo + " foram alterados com sucesso");
            st.close();
            conecta.close();
            
            %>
    </body>
</html>
