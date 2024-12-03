using Microsoft.AspNetCore.Mvc;
using DevReads.Models;

namespace DevReads.Repository
{
    public interface ICarrinhoRepositorio
    {
        public Carrinho ListaLivrosCarrinho();

    }

}