using MySql.Data.MySqlClient;
using MySql.Data.Types;
using Norget.Models;
using System.Data;

// RECEBA (TROCAR O CÓDIGO)

namespace Norget.Repository
{

    // Chamar a interface com herança
    public class UsuarioRepositorio : IUsuarioRepositorio
    {
        //declarando a varival de da string de conexão

        private readonly string? _conexaoMySQL;

        //metodo da conexão com banco de dados
        public UsuarioRepositorio(IConfiguration conf) => _conexaoMySQL = conf.GetConnectionString("ConexaoMySQL");

        //Login Cliente(metodo )

        public Usuario Login(string EmailCli, string SenhaCli)
        {
            //usando a variavel conexao 
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                //abre a conexão com o banco de dados
                conexao.Open();

                // variavel cmd que receb o select do banco de dados buscando email e senha
                MySqlCommand cmd = new MySqlCommand("select * from tbCliente where EmailCli = @Email and SenhaCli = @Senha", conexao);

                //os paramentros do email e da senha 
                cmd.Parameters.Add("@Email", MySqlDbType.VarChar).Value = EmailCli;
                cmd.Parameters.Add("@Senha", MySqlDbType.VarChar).Value = SenhaCli;

                // Lê os dados que foi pego do email e senha do banco de dados
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                // Guarda os dados que foi pego do email e senha do banco de dados
                MySqlDataReader dr;

                // Instanciando a model cliente
                Usuario usuario = new Usuario();
                // Executando os comandos do mysql e passsando paa a variavel dr
                dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                // Verifica todos os dados que foram pego do banco e pega o email e senha
                while (dr.Read())
                {
                    usuario.EmailCli = Convert.ToString(dr["EmailCli"]);
                    usuario.SenhaCli = Convert.ToString(dr["SenhaCli"]);
                }
                return usuario;
            }
        }
        // MÉTODO CADASTRAR CLIENTE
        
        public void Cadastro(Usuario usuario)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();

                using (var cmd = new MySqlCommand("spInsertCliente", conexao))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@vNomeCli", MySqlDbType.VarChar).Value = usuario.NomeCli;
                    cmd.Parameters.Add("@vEmailCli", MySqlDbType.VarChar).Value = usuario.EmailCli;
                    cmd.Parameters.Add("@vSenhaCli", MySqlDbType.VarChar).Value = usuario.SenhaCli;

                    cmd.ExecuteNonQuery();
                    conexao.Close();
                }
            }
        }
        // Listar todos os clientes

        public IEnumerable<Usuario> TodosUsuarios()
        {
            List<Usuario> Usuariolist = new List<Usuario>();

            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                MySqlCommand cmd = new MySqlCommand("SELECT * from tbCliente", conexao);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                conexao.Close();

                foreach (DataRow dr in dt.Rows)
                {
                    Usuariolist.Add(
                            new Usuario
                            {
                                Id = ((int)dr["id"]),
                                NomeCli = ((string)dr["NomeCli"]),
                                EmailCli = ((string)dr["EmailCli"]),
                                SenhaCli = ((string)dr["SenhaCli"]),
                            }
                    );
                }
                return Usuariolist;

            }
        }

        // Buscar todos os clientes por id
        public Usuario ObterUsuario(int Id)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                MySqlCommand cmd = new("SELECT * from tbCliente ", conexao);
                cmd.Parameters.AddWithValue("@id", Id);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                MySqlDataReader dr;

                Usuario usuario = new Usuario();
                // retorna conjunto de resultado ,  é funcionalmente equivalente a chamar ExecuteReader().
                dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                while (dr.Read())
                {
                    usuario.Id = Convert.ToInt32(dr["id"]);
                    usuario.NomeCli = (string)(dr["NomeCli"]);
                    usuario.EmailCli = (string)(dr["EmailCli"]);
                    usuario.SenhaCli = (string)(dr["SenhaCli"]);
                }
                return usuario;
            }
        }

        //Alterar Cliente
        public void Atualizar(Usuario usuario)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                MySqlCommand cmd = new MySqlCommand("Update tbCliente set NomeCli=@Nome, EmailCli=@Email, SenhaCli= @Senha " +
                                                    " where Id=@id ", conexao);

                cmd.Parameters.Add("@id", MySqlDbType.VarChar).Value = usuario.Id;
                cmd.Parameters.Add("@Nome", MySqlDbType.VarChar).Value = usuario.NomeCli;
                cmd.Parameters.Add("@Email", MySqlDbType.VarChar).Value = usuario.EmailCli;
                cmd.Parameters.Add("@Senha", MySqlDbType.VarChar).Value = usuario.SenhaCli;

                cmd.ExecuteNonQuery();
                conexao.Close();
            }
        }

        // Excluir
        public void Excluir(int Id)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                MySqlCommand cmd = new MySqlCommand("delete from tbCliente where Id=@id", conexao);
                cmd.Parameters.AddWithValue("@id", Id);
                int i = cmd.ExecuteNonQuery();
                conexao.Close();
            }
        }

    }

}