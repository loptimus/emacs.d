/** -*- coding: latin-1 -*-
 * 
 * The  contents of this  file are  subject to  the Erlang  Public License,
 * Version  1.1, (the  "License");  you may  not  use this  file except  in
 * compliance  with the License.  You should  have received  a copy  of the
 * Erlang  Public License  along  with this  software.  If not,  it can  be
 * retrieved at http://plc.inf.elte.hu/erlang/
 *
 * Software  distributed under  the License  is distributed  on an  "AS IS"
 * basis, WITHOUT  WARRANTY OF ANY  KIND, either expressed or  implied. See
 * the License  for the specific language governing  rights and limitations
 * under the License.
 *
 * The Original Code is RefactorErl.
 *
 * The Initial Developer of the  Original Code is E�tv�s Lor�nd University.
 * Portions created  by E�tv�s Lor�nd University are  Copyright 2008-2009,
 * E�tv�s Lor�nd University. All Rights Reserved.
 *
 * @author Peter Felker <felker.peter88@gmail.com>
 * 
 */

#include <iostream>
#include <vector>

#include "globals.h"

using namespace std;


graph* globals::ngraph;
persistence* globals::backup_system;
string globals::graphs_dir;
