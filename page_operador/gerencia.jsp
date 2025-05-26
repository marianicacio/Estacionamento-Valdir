<%@page import = "java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="../operador_css/operador.css">
         <style>
    html, body {
    margin: 0;
    padding: 0;
    overflow-x: auto;
  }
    </style>
    </head>
   
    <body>
        <h1 style="font-family: fantasy">Gerenciar estacionamento</h1>
         <div class="gerencia_carro">         
             <form method="post">
                 
                 
                 <%
                 try {
                 //fazer conexão com o banco de dados
                 Connection conecta;
                 PreparedStatement st;
                 String url="jdbc:mysql://localhost:3306/estacionamento_administrador";
                 String user="root";
                 String password="root"; //COLOCAR ROOT
                 conecta = DriverManager.getConnection(url, user, password);
                //Listar os dados da tabela carro do banco de dados
                String sql=("SELECT * FROM carro");
                st=conecta.prepareStatement(sql);
                ResultSet rs= st.executeQuery();
            %>
            
             <table>
                <tr>
                    <th>Placa</th>
                    <th>Data Entrada</th>
                    <th>Hora Entrada</th>
                    <th>Data Saida</th>
                    <th>Hora Saida</th>
                    <th>Preço</th>
                    <th>Excluir</th>
                </tr>
                 <%
                    while(rs.next()){
                    %>
                    
                    <tr class="table-banco">
                    <td>
                        <%=rs.getString("placa")%>
                    </td>
                    <td align="center">
                            <%=rs.getString("data_entrada")%>
                    </td>
                    <td align="center">
                            <%=rs.getString("hora_entrada")%>
                    </td>
                    <td align="center">
                            <%=rs.getString("data_saida")%>
                    </td>
                    <td align="center">
                            <%=rs.getString("hora_saida")%>
                    </td>
                    <td align="center">
                        <p> R$ <%=rs.getString("valor_pago")%> </p>
                    </td>
               <!-- <td>
                 // < % aqui sera o codigo para verificar o numero de vagas totais (tire o espaço antes da porcentagem)%>
                </td> -->
               <td class="Excluir">
                     <a href="../excluirvaga.jsp?placa=<%= rs.getString("placa")%>">Excluir</a>
                </td> 
                </tr>
                 
                  <%
                    }
            %>
                  </table>
            <%
                }catch(Exception x){
                out.print("Mensagem de erro: " + x.getMessage());

                }
           %>
                </form>
                </div>
    </body>
</html>