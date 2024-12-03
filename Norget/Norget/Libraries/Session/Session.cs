namespace Norget.Libraries.Session
{
    public class Session
    {
        IHttpContextAccessor _context;
        public Session(IHttpContextAccessor context)
        {
            _context = context;
        }

        public void Cadastrar(string Key, string Valor) 
        {
            _context.HttpContext.Session.SetString(Key, Valor);
        }

        public string Consultar(string Key)
        {
            return _context.HttpContext.Session.GetString(Key);
        }

        public bool ExisteUsuario(string Key)
        {
            if (_context.HttpContext.Session.GetString(Key) == null)
            {
                return false;
            }
            return true;
        }

        public void RemoveUsuario(string Key)
        {
            _context.HttpContext.Session.Remove(Key);
        }  

        public void RemoveTodos()
        {
            _context.HttpContext.Session.Clear();
        }

        public void AtualizaUsuario(string Key, string Valor)
        {
            if (ExisteUsuario(Key))
            {
                _context.HttpContext.Session.Remove(Key);
            }
            _context.HttpContext.Session.SetString(Key, Valor);
        }
    }
}
