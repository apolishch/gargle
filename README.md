Gargle
======

This gem provides a structure to running arbitrary paths from a state graph, so long as dependencies are known. While an easily approachable testcase is testing,
this framework is in no way limited to it and will randomize a pass through any properly constructed Ruby Code.

Installation:
======

    gem install gargle

Execution:
======

Simply run your ruby code as you usually would using ruby, rspec, or whatever.

How:
======

You can define three entities:

1) A GargleNode like so: 

For the sake of clarity lets assume we have an object `foo` defined with the following keys and values:
    
a)
    `states_required: [:my_awesome_state]`
    
b)
    `states_forbidden: [:my_less_awesome_state]`

c)
    `states_added: [:my_less_awesome_state]`

d)
    `states_removed: [:my_awesome_state]`
    
Then:

```Gargle::node :my_awesome_node, foo do
        -Ruby Code Goes here-
      end```

This will let the framework know that any code given in :`:my_awesome_node` can be run if some previous node has set my_awesome_state, if no previous node has
set my_less_awesome_state, and will modify the state as outlined by states_added, and states_removed.

2) A GargleGroup like so:

    Gargle::group :my_awesome_group....

The syntax is further identical to GargleNodes. This allows for namespacing (through wrapping nodes in groups), and for allowing multiple nodes to set requirements/forbidden/
set/unset.

3) A GargleStateSum like so:

    Gargle:state_sum :login_credentials_valid, [:login_password_valid, :login_email_valid, :login_captcha_valid]

This will reference the array of states by a single state which can then be required/forbidden (but can not be explicitly set).

-----

The following configuration settings are available. They have all been given sensible defaults and will read from all capitals environment variables if those variables are set.

1)
    
    INITIAL_MUTATE_PROBABILITY.
    The probability that an arbitrary gene will mutate at least once. 
    Defaults to 1

2)
    
    MUTATE_DOWN_PROBABILITY
    The probability that an arbitrary mutation will decrease the numeric value of a gene. 
    Defaults to 0.5

3)
    
    APPEND_PROBABILITY
    The probability that an arbitrary recombination will append two genese rather then recombining them (e.g. on an append run [1,2].recombine([3,4]) would become [1,2,3,4]).
    Defaults to 0.05

4)
    
    HEAD_FIRST_RECOMBINE_PROBABILITY
    The probability that given recombination, not appending is occurring, the first gene would provide a head, while the second would provide a tail.
    Defaults to 0.525 (half, given recombine, not append)

5)
   
    HEAD_FIRST_APPEND_PROBABIITY
    The probability that if an append is occurring, the first gene will go first.
    Defaults to 0.5 (this is absolute, not conditional probability)

6)
    
    POPULATION_SIZE
    The upper bound for the number of generations.
    Defaults to 5

7)
    
    INITIAL_POPULATION_SIZE
    The initial number of generated genes.
    Defaults to 5

8)
    
    CONTINUATION_PROBABILITY
    The probability that for an arbitrary pass through the graph, another node will be sought for.
    Defaults to 0.99
