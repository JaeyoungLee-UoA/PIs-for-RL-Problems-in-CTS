# PIs-for-RL-Problems-in-CTS
This repository provides the open source code used to generate the simulation results shown in the paper:

"Jaeyoung Lee and Richard S. Sutton (2021) Policy Iterations for Reinforcement Learning Problems in Continuous Time and Space -- Fundamental Theory and Methods, Automatica, vol. 126, 109421."

To reproduce the results in the paper, please run the code according to the following instruction (tested in MATLAB R2012a (32bit) Edition).

1. To begin with,
    * set the MATLAB working directory to the cloned local repository path in your machine;
    
    * clear the environment using the following commands:
``` octave-workspace 	
	close all
	clear all
	clc
```

2. Use the following commands to reproduce the data corresponding to the simulations in the manuscript.

    * Case 1: Concave Hamiltonian with Bounded Reward (Section 7.1)
      * DPI: **``Main('DPI', 'Con', 'Normal', [20, 21], 50)``**
      * IPI: **``Main('IPI', 'Con', 'Normal', [20, 21], 50)``**

    * Case 2: Optimal Control (Section 7.2)
      * DPI: **``Main('DPI', 'Opt', 'Normal', [20, 21], 50)``**
      * IPI: **``Main('IPI', 'Opt', 'Normal', [20, 21], 50)``**

    * Case 3: Bang-bang Control (Section 7.3)
      * DPI: 
      	* ``Main('DPI', 'Con', 'B-bang', [20, 21], 50)``
      	* ``Main('DPI', 'Opt', 'B-bang', [20, 21], 50)``
      * IPI: 
      	* **``Main('IPI', 'Con', 'B-bang', [20, 21], 50)``**
      	* **``Main('IPI', 'Opt', 'B-bang', [20, 21], 50)``**

    * Case 4: Bang-bang Control with Binary Reward (Section 7.4)
      * DPI: **``Main('DPI', 'Bin', 'B-bang', [20, 20], 50)``**
      * IPI: **``Main('IPI', 'Bin', 'B-bang', [20, 21], 50)``**
      
    The bold cases are required to run in order to draw the figures in the manuscript. Once code has run, the data will be stored in the subfolder ``.\data\``.

3. To draw Fig. 1 in the manuscript from the data obtained in the 2nd step above, run the following commands.

    * Fig 1(a): ``DrawTrjGraph('DPI_Con_Normal', 'Type_1', true)``
    * Fig 1(b): ``DrawTrjGraph('DPI_Opt_Normal', 'Type_2', true)``
    * Fig 1(c): ``DrawTrjGraph('IPI_Con_Normal', 'Type_1', true)``
    * Fig 1(d): ``DrawTrjGraph('IPI_Con_B-bang', 'Type_2', true)``
    * Fig 1(e): ``DrawTrjGraph('DPI_Bin_B-bang', 'Type_3', true)``
    * Fig 1(f): ``DrawTrjGraph('IPI_Bin_B-bang', 'Type_3', true)``
    
    Note:
      * For a fast running, one can replace the last param ``true`` to ``false``; in this case, the yellow lines (intermediate trjs.) are omitted in the figures. 
      * The corresponding data files must be stored in the folder ``.\data\`` a priori (see and run Main.m to generate the data).
      * Fig. 1 in the manuscript was post-processed with fixPSlinestyle library (github.com/djoshea/matlab-utils/tree/master/libs/fixPSlinestyle).

4. Run the followings to draw the value-function-parts in Fig. 2 in the manuscript.

    * Fig 2(a): ``Plot3DVF('DPI_Con_Normal')``
    * Fig 2(b): ``Plot3DVF('IPI_Con_Normal')``
    * Fig 2(e): ``Plot3DVF('DPI_Opt_Normal')``
    * Fig 2(f): ``Plot3DVF('IPI_Opt_B-bang')``
    * Fig 2(i): ``Plot3DVF('DPI_Bin_B-bang')``
    * Fig 2(j): ``Plot3DVF('IPI_Bin_B-bang')``
    
    Note: the corresponding data files must be stored in the subfolder ``.\data\`` a priori (see and run Main.m to generate the data).

5. Run the followings to draw the policy-parts in Fig. 2 in the manuscript.

    * Fig 2(c): ``Plot3DPolicy('DPI_Con_Normal')``
    * Fig 2(d): ``Plot3DPolicy('IPI_Con_Normal')``
    * Fig 2(g): ``Plot3DPolicy('DPI_Opt_Normal')``
    * Fig 2(h): ``Plot3DPolicy('IPI_Opt_B-bang')``
    * Fig 2(k): ``Plot3DPolicy('DPI_Bin_B-bang')``
    * Fig 2(l): ``Plot3DPolicy('IPI_Bin_B-bang')``
    
    Note: the corresponding data files must be stored in the subfolder ``.\data\`` a priori (see and run Main.m to generate the data).

For a bug report or any issue, please send an e-mail to [Dr. Jaeyoung Lee](mailto:ja6@ualberta.ca?subject=[GitHub]%20Bug%20Report%20or%20Any%20Issues).
