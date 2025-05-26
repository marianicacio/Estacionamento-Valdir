<%@page import = "java.sql.*"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String placa;
            placa = request.getParameter("placa");
            
            try{
                // conectar ao banco de dado bancojsp
                Connection connecta;
                PreparedStatement st;
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url="jdbc:mysql://localhost:3306/estacionamento_administrador";
                String user = "root";
                String password = "root";
                connecta = DriverManager.getConnection(url,user,password);
                
                String sql = "DELETE FROM carro WHERE placa = ?";
                st = connecta.prepareStatement(sql);
                st.setString(1,placa);
                int resultado = st.executeUpdate();
                if (resultado == 0){
                    out.print("Este produto não está cadastrado no banco");
            }else{
                    out.print("O carro da placa: " + placa+ " , foi excluido com sucesso");
            }
            }catch (Exception erro){
                String mensagemErro = erro.getMessage();
                out.print( mensagemErro  + "Entre em contato com o administrador e informe o erro");
            }
            
            %>
            
            <h1> Obrigado pela consulta</h1>
            
    </body>
</html>
     
