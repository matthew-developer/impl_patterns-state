# Implementation patterns

## Chapter 6 - State

### State

> Compute with values, that changes over time

Every object has an ´state´, that changes over time. It's ´oo-style´ in contrast to ´value style´ from functional paradigm, where there is no state. Behavior(method) operates on state and creates some control of flow. So it's a good idea to put this logic and data also in the same scope of class. 
In this context you should ask you also a question what to store and what to compute? So the standard store-versus-compute decision. There is not only the state of an object, but also temporal state of method.

To manage the state of an object try always to put similar data together, which have the same lifetime and the similar rate of change. 
It's a part of Separation of concerns principle, but alsa influences tha right symmetry and local consequences. 

```
 PRIVATE SECTION.
 DATA: mv_point_x TYPE i, 
       mv_point_y TYPE i. 
```


### Access

### Direct Access

> Directly access state inside an object. 

Direct access is the lowest level of abstraction. If descriptive and meaningful names have been used, than it's also simple to read, so you have clarity about the implementation detail. However you will loose flexibility and offen break DRY-Principle. If meaningful and descriptiv name have been used, than direct access reveal his intention. In other way it can be challanging. Try to use direct class within constructors and accessor methods. In other methods try to use it on the lowest abstraction of level, so also IOSP-Model won't be broken. 

```
METHOD constructor.
     mv_point_x = iv_point_x. 
     mv_point_y = iv_point_y.     
     mv_register_door = 1.
ENDMETHOD.
```

### Indirect Access

> Access state through a method to provide greater flexibility. 

Try to provide indirect access for clients to the object state - information hidding. 
If the most access to state is outside the class, than we have some design problem, that breaks the law of demeter and Tell don't ask principle. One of the most reason for this issue are accessor methods get. Check if the stored values really belongs to the classes or should be moved to some others. 

Use indirect access for coupled data, where the coupling is very direct. It's like a good API helping not to forget anything. 

```
METHOD set_point_x. 
    mv_point_x = iv_point_x. 
    mv_length  = mv_point_x + mv_point_y. 
ENDMETHOD.
```

We could just set for this data dependency some listener. In this way we can use this method also on some other places and follow the rule of DRY. However the result is a mixed between different types of abstraction levels. 

```
METHOD set_point_x. 
    mv_point_x = iv_point_x. 
    update_length(  ). 
ENDMETHOD.

METHOD update_length.
    mv_length = mv_point_x + mv_point_y.
ENDMETHOD
```

Well on other hand we can consider this as violance of DRY on data. The information about the length can be directly calculated from the point x and y, without storing it as a instance variable. Maybe a better way would be just to compute on two stored values and return some result. It's a store-versus-compute decision. 

```
METHOD calculate_length. 
    rv_length = mv_point_x + mv_point_y. 
ENDMETHOD.
```

## Common state

> Store the state common to all objects of a class as fields

Objects of the same class have always the same data elements(member variables). You can change it only during the compile time. It's like the inheritance, where every object inheritates behavior from the above classes. You just can't change it during the runtime of the programms. There is no dynamic in the state, so if some issues occur, than you can first take a look at the source. 

```
PRIVATE SECTION.
  DATA: mv_point_x TYPE i, 
        mv_point_y TYPE i,
        mv_length  TYPE i,
        mv_register_door TYPE i.
```

## Variable state

As mentioned before with inheritance you have no dynamic to add some new behavior to object during the runtime. However if you are using delegation with observer design pattern you can achieve this goal. 
The same thing we can make with the state of an object. Just use some generic types and you have totally dynamic object. It won't be so nice if you suddenly get some problems in the production. 

```
PRIVATE SECTION.
  DATA: mt_property TYPE tt_property.

METHOD set_property.
    DATA: ls_property TYPE ts_property.
          ls_property-property_name  = iv_property_name.
          ls_property-property_value = iv_property_value.

          APPEND ls_property TO mt_property.
ENDMETHOD.

```

## local variable

> local variables hold state for single scope

Use local variables for short scopes, like within a single method. There are some common principles for using local variables.

Common roles
- collector  : collect information for the later use 
- count      : collects count of some other object 
- explaining : reducing complexity destroying long, complicated expressions. 

Common uses
- resue   : need to use the same value over and over 
- element : hold elements of a collection, that is itareting. 

You can decrease the scope of a local variable, using it as an importing parameter for some other methods or saving it as some record in the instance table variable. 

```
METHOD compute_some_values. 
    DATA: lv_counter TYPE i.         
    LOOP AT mt_property INTO DATA(ls_property).
        IF lv_counter = 10. 
            contact_support( iv_message = 'ERROR' is_property = ls_property ).
        ELSE. 
            lv_counter = lv_counter + 1. 
            contact_support( iv_message = 'OK' is_property = ls_property ).
        ENDIF.
    ENDLOOP.
ENDMETHOD.
```

## Field

> Fields store state for the life of an object. 

Fields stores state values for an object. The are some roles for using fields in the object scope. 
Roles: 
- helper  : hold references to objects used by many methods. 
            If object is passed to many methods as parameter replace it with helper-field in the                   constructor. 
-flag     : object can act in two different ways. If setter method is provided, than the behavior of               the object can change durign the runtime. Use it only in few conditions. 
-strategy : some part of an object's computation can behave in other way. 
            If the behavior can change during the life of the object provide setters, otherwise pass it             with help of the constructor.
-state    : like strategy-fields, but it is set within the object, not from outside. 
-components: objects or data owned by reffering object. Composition or Aggragation. 

### Parameters

> Parameters communicate state during the activation of a single method. 

If the same parameter is using by several methods of an object consider to attach it as a field to the referring object. Use it for public and private methods. 
Coupling with parameters is weaker than permanent using reference object(Helper object).

### Collecting Parameter

> Pass a parameter to collect complicated results from multiple methods.

Merge all return parameters from all methods. If value have a primitive type like an integer, than it's no problem. Otherwise pass parameter, that will collect the results for example an object. 

```
METHOD collect_values. 
    LOOP AT mt_values INTO DATA(ls_value).
        rv_result = rv_result + ls_value-size. 
    ENDLOOP.
ENDMETHOD.
```

### Optional Parameter

> Default parameter for default behavior.

Put in the interface of a method first mandatory parameters and than optional ones. 
Default parameters can increase the readability of a method, because the reader doesn't have some additionally information. It can provide also some flexibility to create one method with different optional parameters instead of several methods. 

```
METHOD calculate_salary. 
    calculate_salary( iv_worker_id = 100 ).
    calculate_salary( iv_worker_name = 'Johnson' ).
ENDMETHOD.
```

### Parameter objects

> consolidate frequently used long parameter lists into an object. 

Perfect Method consists of one import parameter and one returning parameter. However methods without parameterlist are also very helpful. If you have a method with a long parameter list, try to put the data in a helper object of course if data is strong coupled. In otherwise two object might be also possible, however try to change the design in order to achieve goal of a perfect method. 

```
mo_object->set_bounderies( iv_color = 'blue'  iv_round_corners = abap_true iv_width = 20 ).

DATA(lo_border) = new ycl_border( iv_color = 'blue' iv_rounded_corners = abap_true iv_width = 20 ).
mo_object->set_bounderies2( lo_border ).
```

If you passing an object as the argument for a method, it has also some kind of state. So if you would like to change some state of the object, than provide the right methods for this change. It can bring a new wave of innovation. Remember to use chaining in this context, cause the method is expecting some object as returning value. 

```
mo_object->set_bounderies2( lo_border->quadrate_corners(  ) ).

METHOD quadrate_corners.
    ro_object = new ycl_border( iv_color = mv_color iv_rounded_corners = abap_false iv_width = mv_width ).
ENDMETHOD.
```

### Constants

> Store state that doesn't vary as a constant.

Constant never change. Try to use meaningful and descriptiv name for it. 

```
mo_object->set_bounderies( iv_color = 'blue'  iv_round_corners = abap_true iv_width = 20 ).
mo_object->set_bounderies( iv_color = mc_color_blue  iv_round_corners = abap_true iv_width = mc_middle_width  ).
```

### Role Suggesting Names

> Name variables declaratively as much as possible

Meaningful names to maximize clarity is the key to read a source code like a book. 
Communicate the role of variable. 
```
  DATA: mv_name TYPE string,  
```
Do not necessary communicate scope, lifetime or primitive types (Hungarian Notation). Also don't include the name of the class where the field is declared. 
```
  DATA: mv_name_string TYPE string, 
        mv_id_scope_middle TYPE i, 
        mv_name_for_worker TYPE string. 
```

Sometimes it can be possible to encode in the returning parameter name of a method some complex structures. The reader will already notice what kind of methods, that object included. 

```
METHOD: count_company_workers
           IMPORTING iv_company_id TYPE i
           RETURNING VALUE(rv_workers_list) TYPE REF TO ycl_list. 
```

### Declared Type

> Declare a general type for variables. 

There are two ways of declaring types. First one ist just to use direct types, which communicate the usage very well. Second option is to use general declared types, which allows more flexibility in the future, but deliver less information.

```
METHOD: count_chars
          IMPORTING iv_input TYPE char10.
          
METHOD: count_chars 
          IMPORTING iv_input TYPE c. 
          
METHOD: count_chars 
          IMPORTING iv_input TYPE string. 
          
METHOD: count_chars 
          IMPORTING iv_input TYPE csequence. 
          
METHOD: count_chars 
          IMPORTING iv_input TYPE clike. 
          
METHOD: count_chars 
          IMPORTING iv_input TYPE any. 
```

### Eager Initialization 

> Initialize fields at instance creation time.

For symmetry principle is a good idea to initialize everything at the same place. Best place for this is constructor. You can be sure, that your fields are there, before they will be used. 

```
METHOD constructor.
    mv_point_x = iv_point_x.
    mv_point_y = iv_point_y.
    mv_register_door = 1.
ENDMETHOD.
```

### Lazy Initialization

Initialize the fields first, when you are forced to use them. It's a good point for performance. You can find this concept in the web. The concept is also used in singleton design pattern. 

```
METHOD get_counter. 
 IF mo_counter IS INITIAL. 
   ro_counter = new ycl_counter( ).
 ELSE. 
   ro_counter = mo_counter.
 ENDIF.
ENDMETHOD.
```


It works fine, but maybe this variant is looking much better, if you want to read everything like a book, you should hold same logic and data close to each other.


```
METHOD get_counter. 
 IF mo_counter IS NOT INITIAL. 
   ro_counter = mo_counter.
 ELSE. 
   ro_counter = new ycl_counter( ).
 ENDIF.
ENDMETHOD.
```
