#include <ros/ros.h>
//#include <mdm_library/controller_event_mdp.h>
#include <mdm_library/sarsa_learning_mdp.h>

using namespace std;
using namespace ros;
using namespace mdm_library;

int main ( int argc, char** argv )
{
    init ( argc, argv, "control_layer" );

    if ( argc < 4 )
    {
        ROS_ERROR ( "Usage: rosrun mdm_example demo_control_layer <path to policy file>" );
        abort();
    }

    string policy_path = argv[1];
    string reward_path = argv[2];
    string q_values_path = argv[3];

    //ControllerEventMDP cl ( policy_path );

    std::cout << "Starting..." << std::endl;

    ALPHA_TYPE alpha = ALPHA_ONE_OVER_T;
    EPSILON_TYPE epsilon = EPSILON_ONE_OVER_T;
    CONTROLLER_TYPE controller = EVENT;

    std::cout << "Types set..." << std::endl;

    uint32_t num_states = 8;
    uint32_t num_actions = 4;

    SarsaLearningMDP sarsa ( alpha, epsilon, controller, num_states, num_actions, policy_path, reward_path, q_values_path );

    std::cout << "Spinning..." << std::endl;

    spin();

    return 0;
}
