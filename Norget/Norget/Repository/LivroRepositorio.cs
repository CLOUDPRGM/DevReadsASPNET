using MySql.Data.MySqlClient;
using MySql.Data.Types;
using Norget.Models;
using System.Data;
namespace Norget.Repository
{
    public class LivroRepositorio : ILivroRepositorio
    {
        private readonly string? _conexaoMySQL;

        //metodo da conexão com banco de dados
        public LivroRepositorio(IConfiguration conf) => _conexaoMySQL = conf.GetConnectionString("ConexaoMySQL");

        public IEnumerable<Livro> ListarLivros()
        {
            List<Livro> LivroList = new List<Livro>();

            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                MySqlCommand cmd = new MySqlCommand("select * from vw_Livro", conexao);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                conexao.Close();

                // Agora o retorno ocorre depois de preencher a lista
                foreach (DataRow dr in dt.Rows)
                {
                    LivroList.Add(
                        new Livro
                        {
                            IdLiv = (int)(dr["IdLiv"]),
                            ISBN = (decimal)(dr["ISBN"]),
                            NomeLiv = (string)(dr["NomeLiv"]),
                            PrecoLiv = (decimal)(dr["PrecoLiv"]),
                            DescLiv = (string)(dr["DescLiv"]),
                            ImgLiv = (string)(dr["ImgLiv"]),
                            IdEdi = (int)(dr["IdEdi"]),
                            NomeEdi = (string)(dr["NomeEdi"]),
                            IdCategoria = (int)(dr["IdCategoria"]),
                            NomeCategoria = (string)(dr["NomeCategoria"]),
                            Autor = (string)(dr["Autor"]),
                            DataPubli = (DateTime)(dr["DataPubli"]),
                            EspeciaLiv = Enum.TryParse(typeof(Livro.EspecialLiv), dr["EspecialLiv"]?.ToString(), out var result)
                            ? (Livro.EspecialLiv)result
                            : Livro.EspecialLiv.N
                        });
                }
                return LivroList;
            }
        }

        public Livro ObterLivro(int IdLiv)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                MySqlCommand cmd = new("SELECT * FROM vw_Livro where IdLiv = @IdLiv", conexao);
                cmd.Parameters.AddWithValue("@IdLiv", IdLiv);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                MySqlDataReader dr;

                Livro livro = new Livro();
                // retorna conjunto de resultado ,  é funcionalmente equivalente a chamar ExecuteReader().
                dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                while (dr.Read())
                {
                    livro.IdLiv = Convert.ToInt32(dr["IdLiv"]);
                    livro.ISBN = Convert.ToDecimal(dr["ISBN"]);
                    livro.NomeLiv = (string)(dr["NomeLiv"]);
                    livro.PrecoLiv = (decimal)(dr["PrecoLiv"]);
                    livro.DescLiv = (string)(dr["DescLiv"]);
                    livro.ImgLiv = (string)(dr["ImgLiv"]);
                    livro.IdCategoria = (int)(dr["IdCategoria"]);
                    livro.NomeCategoria = (string)(dr["NomeCategoria"]);
                    livro.IdEdi = Convert.ToInt32(dr["IdEdi"]);
                    livro.NomeEdi = (string)(dr["NomeEdi"]);
                    livro.Autor = (string)(dr["Autor"]);
                    livro.DataPubli = (DateTime)(dr["DataPubli"]);
                    livro.EspeciaLiv = Enum.TryParse(typeof(Livro.EspecialLiv), dr["EspecialLiv"]?.ToString(), out var result)
                                                 ? (Livro.EspecialLiv)result
                                                 : Livro.EspecialLiv.N;
                }
                return livro;
            }
        }

        public void CadastroLivro(Livro livro)
        {

            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();

                using (var cmd = new MySqlCommand("spInsertLivro", conexao))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    var dataPubli = livro.DataPubli?.ToString("dd/MM/yyyy");

                    cmd.Parameters.Add("@vISBN", MySqlDbType.Decimal).Value = livro.ISBN;
                    cmd.Parameters.Add("@vNomeLiv", MySqlDbType.VarChar).Value = livro.NomeLiv;
                    cmd.Parameters.Add("@vPrecoLiv", MySqlDbType.Decimal).Value = livro.PrecoLiv;
                    cmd.Parameters.Add("@vDescLiv", MySqlDbType.VarChar).Value = livro.DescLiv;
                    cmd.Parameters.Add("@vImgLiv", MySqlDbType.VarChar).Value = livro.ImgLiv;
                    cmd.Parameters.Add("@vNomeCategoria", MySqlDbType.VarChar).Value = livro.NomeCategoria;
                    cmd.Parameters.Add("@vNomeEdi", MySqlDbType.VarChar).Value = livro.NomeEdi;
                    cmd.Parameters.Add("@vAutor", MySqlDbType.VarChar).Value = livro.Autor;
                    cmd.Parameters.Add("@vDataPubli", MySqlDbType.VarChar).Value = livro.DataPubli?.ToString("dd/MM/yyyy");
                    cmd.Parameters.Add("@vEspecialLiv", MySqlDbType.Enum).Value = livro.EspeciaLiv;
                    cmd.Parameters.Add("@vNoCarrinho", MySqlDbType.Int32).Value = livro.NoCarrinho;

                    cmd.ExecuteNonQuery();
                    conexao.Close();
                }
            }
        }
        public Livro AddAoCarrinho(int IdLiv)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();

                MySqlCommand cmd = new MySqlCommand("UPDATE tbLivro set NoCarrinho = true where IdLiv = @IdLiv", conexao);
                cmd.Parameters.AddWithValue("@IdLiv", IdLiv);

                cmd.ExecuteNonQuery();

                return new Livro
                {
                    NoCarrinho = true
                };
            }
        }

        public Livro RemoveDoCarrinho(int IdLiv)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();

                // Comando para atualizar o banco
                MySqlCommand cmd = new MySqlCommand("UPDATE tbLivro set NoCarrinho = false where IdLiv = @IdLiv", conexao);
                cmd.Parameters.AddWithValue("@IdLiv", IdLiv);

                // Executar o comando de atualização
                cmd.ExecuteNonQuery();

                // Retorna o objeto Produto atualizado
                return new Livro
                {
                    NoCarrinho = false
                };
            }
        }

        public List<Livro> BuscarLivroPorNome(string pesquisa)
        {

            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {

                conexao.Open();


                MySqlCommand cmd = new MySqlCommand("select * from vw_Livro where NomeLiv like @NomeLiv", conexao);
                cmd.Parameters.Add("@NomeLiv", MySqlDbType.String).Value = "%" + pesquisa + "%";

                // Lê os dados que foi pego do email e senha do banco de dados
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                // Guarda os dados que foi pego do email e senha do banco de dados
                MySqlDataReader dr;

                // Instanciando a model cliente
                List<Livro> listaLivro = new List<Livro>();
                // Executando os comandos do mysql e passsando paa a variavel dr
                dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                // Verifica todos os dados que foram pego do banco e pega o email e senha
                while (dr.Read())
                {
                    Livro livro = new Livro();

                    livro.IdLiv = Convert.ToInt32(dr["IdLiv"]);
                    livro.NomeLiv = Convert.ToString(dr["NomeLiv"]);
                    livro.PrecoLiv = Convert.ToDecimal(dr["PrecoLiv"]);
                    livro.ImgLiv = Convert.ToString(dr["ImgLiv"]);
                    livro.NomeEdi = Convert.ToString(dr["NomeEdi"]);
                    livro.Autor = Convert.ToString(dr["Autor"]);
                    livro.DataPubli = Convert.ToDateTime(dr["DataPubli"]);

                    listaLivro.Add(livro);
                }
                return listaLivro;
            }
        }

        public void AtualizarLivro(Livro livro)
        {
            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                using (var cmd = new MySqlCommand("spUpdateLivro", conexao))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@vIdLiv", MySqlDbType.Int32).Value = livro.IdLiv;
                    cmd.Parameters.Add("@vISBN", MySqlDbType.Decimal).Value = livro.ISBN;
                    cmd.Parameters.Add("@vNomeLiv", MySqlDbType.VarChar).Value = livro.NomeLiv;
                    cmd.Parameters.Add("@vPrecoLiv", MySqlDbType.Decimal).Value = livro.PrecoLiv;
                    cmd.Parameters.Add("@vDescLiv", MySqlDbType.VarChar).Value = livro.DescLiv;
                    cmd.Parameters.Add("@vImgLiv", MySqlDbType.VarChar).Value = livro.ImgLiv;
                    cmd.Parameters.Add("@vNomeCategoria", MySqlDbType.VarChar).Value = livro.NomeCategoria;
                    cmd.Parameters.Add("@vNomeEdi", MySqlDbType.VarChar).Value = livro.NomeEdi;
                    cmd.Parameters.Add("@vAutor", MySqlDbType.VarChar).Value = livro.Autor;
                    cmd.Parameters.Add("@vDataPubli", MySqlDbType.VarChar).Value = livro.DataPubli?.ToString("dd/MM/yyyy");
                    cmd.Parameters.Add("@vEspecialLiv", MySqlDbType.Enum).Value = livro.EspeciaLiv;
                    cmd.Parameters.Add("@vNoCarrinho", MySqlDbType.Int32).Value = livro.NoCarrinho;

                    cmd.ExecuteNonQuery();
                    conexao.Close();

                }
            }
        }
    }
}
