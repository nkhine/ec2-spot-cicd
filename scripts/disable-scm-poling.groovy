import hudson.model.*
import hudson.triggers.*


int hourMax = 23 // could be 8, for 8am, before everyone comes in... 
int minMax = 59
int incr = 15
int hr = 0
int m = 0


for(item in Hudson.instance.items) {
    item.triggers.each{ descriptor, trigger ->
        if(trigger instanceof TimerTrigger) {
            println("--- Timer trigger for " + item.name + " ---")
            println(trigger.spec + '\n')
            item.disable()
            if(item.name != "merge-process"){
                item.removeTrigger descriptor
                item.save()
                item.addTrigger(new TimerTrigger("* * * * *"))
                item.save()
                println "updated to * * * * *"
                m += incr
            }
                       
            
            if(m > minMax){ hr++; m = 0}
            if(hr > hourMax) { hr = 0; }
        }
    }
}