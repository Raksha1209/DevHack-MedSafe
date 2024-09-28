pragma solidity ^0.6.6;

import './MedicineD_C.sol';

///  Customer Medicine Tracking Contract
/// This contract manages medicine batches received by a customer.
contract ClientMedicineTracker {
    
    /// Mapping of customers and their asso medicine batches.
    mapping(address => address[]) public customerMedicines;
    
    ///  Mapping of medicine batches - current sales state.
    mapping(address => SaleState) public medicineSaleStatus;

    /// sales states of a medicine batch.
    enum SaleState {
        Missing,
        WithClient,
        Sold,
        Expired,
        Damaged
    }

    /// Event-when the sales state of a medicine changes.
    event MedicineStateChange(address indexed medicineAddr, address indexed client, uint newState);

    /// Function-record the receipt-medicine-by a client.
   
    function receiveMedicineAtClient(address medicineAddr, address clientID) public {
        MedicineD_C(clientID).receiveDC(medicineAddr, msg.sender);
        customerMedicines[msg.sender].push(medicineAddr);
        medicineSaleStatus[medicineAddr] = SaleState.WithClient;
    }

    /// @notice Function-update the sales state of a medicine batch.
    
    function changeMedicineState(address medicineAddr, uint newState) public {
        medicineSaleStatus[medicineAddr] = SaleState(newState);
        emit MedicineStateChange(medicineAddr, msg.sender, newState);
    }

    /// @notice Function to get the sales state of a medicine batch.
    
    function getMedicineState(address medicineAddr) public view returns(uint) {
        return uint(medicineSaleStatus[medicineAddr]);
    }
}
