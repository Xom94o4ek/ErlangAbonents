Команды:
- Добавление абонента:				create_abonent("Имя_абонента", Квота).		Пример: create_abonent('User1',1000).
- Удаление абонета:				delete_abonent("Имя_абонента").			Пример: delete_abonent('User1').
- Изменение квоты абоненту:			edit_kvota("Имя_абонента", +/- Дельта квоты).	Пример: edit_kvota('User1',200).
- Установить квоту абоненту:			set_kvota("Имя_абонента", Квота).		Пример: set_kvota('User1',500).
- Проверка квоты абонента:			check_abonent("Имя_абонента").			Пример: check_abonent('User1').
- Показать значения квот всех абонентов:	show_abonents().				Пример: show_abonents().

Результаты:

7> main:create_abonent('User1',1000).
{created,{'User1',1000}}
8> main:create_abonent('User1',1000).
{error,abonent_already_exists}
9> main:create_abonent('User2',-1).  
{error,kvota_less_than_0}
10> main:create_abonent('User2',1500).
{created,{'User2',1500}}
11> main:create_abonent('User3',1800).
{created,{'User3',1800}}
12> main:show_abonents().
[{'User1',1000},{'User2',1500},{'User3',1800}]
13> main:set_kvota('User55',5).
{error,abonent_does_not_exist}
14> main:set_kvota('User1',-5).
{error,kvota_less_than_0}
15> main:set_kvota('User1',500).
{edited,{'User1',500}}
16> main:show_abonents().       
[{'User1',500},{'User2',1500},{'User3',1800}]
17> main:edit_kvota('User1',200).
{edited,{'User1',700}}
18> main:show_abonents().        
[{'User1',700},{'User2',1500},{'User3',1800}]
19> main:edit_kvota('User1',-200).
{edited,{'User1',500}}
20> main:show_abonents().         
[{'User1',500},{'User2',1500},{'User3',1800}]
21> main:check_abonent('User55').
{error,abonent_does_not_exist}
22> main:check_abonent('User2'). 
{'User2',1500}
23> main:check_abonent('User3').
{'User3',1800}
24> main:delete_abonent('User55').
{error,abonent_does_not_exist}
25> main:delete_abonent('User2'). 
{deleted,'User2'}
26> main:show_abonents().         
[{'User1',500},{'User3',1800}]
