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
                MySqlCommand cmd = new MySqlCommand("select * from tbLivro", conexao);

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
                            Categoria = (string)(dr["Categoria"]),
                            IdEdi = (int)(dr["IdEdi"]),
                            NomeEdi = (string)(dr["NomeEdi"]),
                            Autor = (string)(dr["Autor"]),
                            DataPubli = (DateTime)(dr["DataPubli"])

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
                MySqlCommand cmd = new("SELECT * FROM tbLivro WHERE IdLiv = @IdLiv", conexao);
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
                    livro.Categoria = (string)(dr["Categoria"]);
                    livro.IdEdi = Convert.ToInt32(dr["IdEdi"]);
                    livro.NomeEdi = (string)(dr["NomeEdi"]);
                    livro.Autor = (string)(dr["Autor"]);
                    livro.DataPubli = (DateTime)(dr["DataPubli"]);

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
                    cmd.Parameters.Add("@vCategoria", MySqlDbType.VarChar).Value = livro.Categoria;
                    cmd.Parameters.Add("@vNomeEdi", MySqlDbType.VarChar).Value = livro.NomeEdi;
                    cmd.Parameters.Add("@vAutor", MySqlDbType.VarChar).Value = livro.Autor;
                    cmd.Parameters.Add("@vDataPubli", MySqlDbType.VarChar).Value = livro.DataPubli?.ToString("dd/MM/yyyy");


                    cmd.ExecuteNonQuery();
                    conexao.Close();
                }
            }

        }
    }
}
