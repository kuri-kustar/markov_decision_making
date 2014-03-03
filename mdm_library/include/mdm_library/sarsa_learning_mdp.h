/**\file sarsa_learning_mdp.h
 *
 * Author:
 * Pedro Resende <pt.resende@gmail.com>
 *
 * Markov Decision Making is a ROS library for robot decision-making based on MDPs.
 * Copyright (C) 2014 Instituto Superior Tecnico, Instituto de Sistemas e Robotica
 *
 * This file is part of Markov Decision Making.
 *
 * Markov Decision Making is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Markov Decision Making is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _SARSA_LEARNING_MDP_H_
#define _SARSA_LEARNING_MDP_H_


#include <mdm_library/online_learning_mdp.h>


namespace mdm_library
{
/**
 * SarsaLearningMDP is the class for the Sarsa learning method.
 */
class SarsaLearningMDP : public OnlineLearningMDP
{
public:
#ifdef HAVE_MADP
    SarsaLearningMDP ( float alpha,
                       float gamma,
                       const std::string& policy_file_path,
                       const std::string& problem_file_path,
                       const ControlLayerBase::CONTROLLER_STATUS initial_status = ControlLayerBase::STARTED );
#endif

    SarsaLearningMDP ( float alpha,
                       float gamma,
                       const std::string& policy_file_path,
                       const ControlLayerBase::CONTROLLER_STATUS initial_status = ControlLayerBase::STARTED );
    
private:
    /** Current state backup */
    uint32_t state_;
    
    /** Current action backup */
    uint32_t action_;
    
    /** Current reward backup */
    float reward_;
    
    /** Next state backup */
    uint32_t next_state_;
    
    /** Next action backup */
    uint32_t next_action_;
    
    /** Implementation of the pure virtual function updateQValues from OnlineLearningMDP */
    void updateQValues ();
    
    /** Implementation of the pure virtual function stateSymbolCallback from OnlineLearningMDP */
    void stateSymbolCallback ( const mdm_library::WorldSymbolConstPtr& msg );
    
    /** Implementation of the pure virtual function actionSymbolCallback from OnlineLearningMDP */
    void actionSymbolCallback ( const mdm_library::ActionSymbolConstPtr& msg );
    
    /** Implementation of the pure virtual function rewardSymbolCallback from OnlineLearningMDP */
    void rewardSymbolCallback ( const std_msgs::Float32& msg );
};
}


#endif