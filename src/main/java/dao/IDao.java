package dao;


import java.util.List;

public interface IDao<T,ID> {
    public T findById(ID id);
    public List<T> findAll();
    public void save(T entity);
    public void update(T entity);
    public void delete(T entity);

}
