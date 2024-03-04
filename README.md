# A Sharing Framework for Energy and Computing Resources in Multi-Operator Mobile Networks

Energy Harvesting (EH) and Multi-access Edge Computing (MEC) are combined in this project to build energy-sustainable mobile networks. We consider an edge infrastructure shared among several mobile operators and equipped with a solar EH farm for energy efficiency purposes together with an edge MEC server for low-latency computation, where two main goals are pursued: (i) to maximally and fairly exploit the available resources at the edge, allotting them among Base Stations (BSs) belonging to different operators; and (ii) to decrease the monetary cost incurred by energy purchases from the power grid. 

To do so, we devise an online framework combining Artificial Neural Network (ANN)-based pattern forecasting that learns energy harvesting and traffic load profiles over time, and Model Predictive Control (MPC)-based adaptive algorithms.

Numerical results, obtained with real-world harvested energy, traffic load, and energy price traces, show that our proposal
effectively reduces the amount of purchased energy from the electrical grid by more than 50% with respect to the case where
no EH is considered, and by about 30% with respect to the case where the optimization is performed disregarding future energy
and traffic load forecasts. Moreover, it is capable of reducing the energy consumption related to edge computation by about 20%
with respect to two benchmark policies.

This is the code repository of the project. You can find more information about it here: https://ieeexplore.ieee.org/document/8944304