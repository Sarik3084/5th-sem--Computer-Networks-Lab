//ID:2014UCP1159 NAME:PUROHIT PRINCE

#include <stdio.h>
#include <string.h>
#include "agent.h"
class MyAgent : public Agent {
public:
        MyAgent();
protected:
        int command(int argc, const char*const* argv);
private:
        int    var1;
        double var2;
        void   myFunc(void);
};
static class MyAgentClass : public TclClass {
public:
        MyAgentClass() : TclClass("Agent/MyAgentOtcl") {}
        TclObject* create(int, const char*const*) {
                return(new MyAgent());
        }
} class_my_agent;
MyAgent::MyAgent() : Agent(PT_UDP) {
       bind("var1", &var1);
       bind("var2", &var2);
}
int MyAgent::command(int argc, const char*const* argv) {
      if(argc == 2) {
           if(strcmp(argv[1], "myfunc") == 0) {
                  myFunc();
                  return(TCL_OK);
           }
      }
      return(Agent::command(argc, argv));
}
void MyAgent::myFunc(void) {
      Tcl& tcl = Tcl::instance();
      tcl.eval("puts \"Message From myFunc\"");
      tcl.evalf("puts \"     var1 = %d\"", var1);
      tcl.evalf("puts \"     var2 = %f\"", var2);
}
