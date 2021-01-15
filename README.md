Работал над рефакторингом сам. Вижу, что есть куда стремиться еще (первая мысль, это то, что можно где-то еще generics использовать) и т.д


## Структура

### PersistenceManager

PersistenceManager— хранилище юзеров. Юзеры хранятся в словаре, который является приватным свойством, чтобы не было доступа напрямую извне. Данный менеджер реализован как синглтон чтобы иметь возможность сохранять добавленных пользователей в рантайме. Так же этот менеджер дает возможность работать другим менеджерам более высшего уровня с помощью своих методов, например
```bash
func saveInteractedUserChanges(changedUser: User)
```
чтобы сохранить в словарь изменения, которые выполнили другие менеджеры над этим юзером

### AuthorizationManager

AuthorizationManager — менеджер, который управляет авторизацией и другими связанными действиями. Немного беспокоит что функционал схож на тот, что предоставляет PersistenceManager, хотелось бы услышать, нормально ли это. Этот менеджер берет в качестве зависимости экземпляр класса, который подписан под PersistenceManagerProtocol

### UserInteractionManager

UserInteractionManager — менеджер, который работает непосредственно с действиями пользователя (обрабатывает действия, которые доступны в главном меню пользователя, а именно: поставить ставку, получить список пользователей, забанить пользователя и т.д.), то есть это менеджер самого высокого уровня. Возможно, нужно было этот менеджер разделить на несколько файлов, но я решил, что в данном случае не нужно. В качестве зависимости данный класс берет сущность, которая имплементирует AuthorizationManagerProtocol.

