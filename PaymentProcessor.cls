public class PaymentProcessor {

public class NameException extends Exception{}

public static final Map<String,PaymentService> strategies;

static{

  SupportedPayProcessors__c payProcessorList = SupportedPayProcessors__c.getall().values();
  
  List<String> strategyNames = new List<String>();
  Loop payProcessorList in payProcessor
    Add strategyNames.add(payProcessor.Name)
  
  strategies = new Map<String,PaymentService>();
  
  for(String name : strategyNames){
    try{
    
      strategies.put(name,(PaymentService)Type.forName(name+'Implementation').newInstance());
    
    }catch(Exception e){
       continue;
    } //skip bad config silently
  }
}

 private PaymentService strategy;

  public PaymentProcessor(String processorType){
    if(!strategies.containsKey(processorType)) throw new NameException();
    strategy = strategies.get(processorType);
  }

  public TransactionResult processPayment(TransactionDetail transactionDetails){
    return strategies.processPayment(transactionDetails);
  }
}
