<%@page import = "java.sql.Connection"%>
<%@page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
           String cargo = request.getParameter("cargo");
           String email = request.getParameter("email");
           String senha = request.getParameter("senha");
           String senhadnv = request.getParameter("senhadnv");

        if (!senha.equals(senhadnv)) {
    %>
            <h2 style="color: red;">Erro: As senhas não coincidem. Tente novamente.</h2>
            <a href="../cadfunc.html">Voltar ao cadastro</a>
    <%
        } else {
            try{
          Connection conecta;
          PreparedStatement st; // Este objeto permite enviar vários comandos SQL
          // como um grupo único para um banco de dados.
          Class.forName("com.mysql.cj.jdbc.Driver"); // Este método é usado para que
          // o servidor de aplicação faça o registro do driver do Banco.
          String url="jdbc:mysql://localhost:3306/estacionamento_administrador";
          String user="root";
          String password="root";
         
          conecta= DriverManager.getConnection(url,user,password);
          //Inserindo dados na tabela do banco de dados
          String sql = ("INSERT INTO usuario (email, senha, cargo) VALUES (?, ?, ?)");
          st=conecta.prepareStatement(sql);
          st.setString(1,email);
          st.setString(2,senha);
          st.setString(3,cargo);
          
          st.executeUpdate(); // Executar a instrução Insert
         
          st.close();
          conecta.close();
          
            }catch (Exception x){
                String erro=x.getMessage();
                if (erro.contains("Duplicate entry")){
                out.print("<p style='color:red; font-family: fantasy; font-size:25px'> ❌ Este usuario ja está cadastrado</p>");
                return;
            }else{
                out.print("<p style='color:red;font-size:25px'>Mensagem de erro: " + erro + "</p>");
            }
           
            }

    %>
            <h2 style="color: green;">Funcionário cadastrado com sucesso!</h2>
            <p><strong>Cargo:</strong> <%= cargo %></p>
            <p><strong>Usuário:</strong> <%= email %></p>
    <%
        }
        
    %>
            
    </body>
</html>
