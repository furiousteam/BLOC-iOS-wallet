//
//  TransactionStore.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

class TransactionDiskStore: TransactionStore {
    /*std::shared_ptr<WalletRequest> WalletTransactionSender::makeSendRequest(TransactionId& transactionId, std::deque<std::shared_ptr<WalletLegacyEvent>>& events,
        const std::vector<WalletLegacyTransfer>& transfers, uint64_t fee, const std::string& extra, uint64_t mixIn, uint64_t unlockTimestamp) {
    
        using namespace CryptoNote;
    
        throwIf(transfers.empty(), error::ZERO_DESTINATION);
        validateTransfersAddresses(transfers);
        uint64_t neededMoney = countNeededMoney(fee, transfers);
    
        std::shared_ptr<SendTransactionContext> context = std::make_shared<SendTransactionContext>();
    
        context->foundMoney = selectTransfersToSend(neededMoney, 0 == mixIn, context->dustPolicy.dustThreshold, context->selectedTransfers);
        throwIf(context->foundMoney < neededMoney, error::WRONG_AMOUNT);
    
        transactionId = m_transactionsCache.addNewTransaction(neededMoney, fee, extra, transfers, unlockTimestamp);
        context->transactionId = transactionId;
        context->mixIn = mixIn;
    
        if(context->mixIn) {
            std::shared_ptr<WalletRequest> request = makeGetRandomOutsRequest(context);
            return request;
        }
    
        return doSendTransaction(context, events);
    }*/
    
    func send(destinations: [TransactionDestinationModel], mixin: UInt, paymentId: String?, fee: Double, keyPair: KeyPair, completion: @escaping TransactionStoreSendCompletionHandler) {
        completion(.success(result: true))
        
        guard fee >= Constants.minimumFee else {
            completion(.failure(error: .feeTooLow))
            return
        }
        
        let invalidDestinationAddresses = destinations.map({ try? $0.address.validate() }).filter({ $0 == nil })
        
        guard invalidDestinationAddresses.isEmpty else {
            completion(.failure(error: .invalidDestinationAddresses))
            return
        }
        
        let invalidAmounts = destinations.map({ $0.amount }).filter({ $0 == 0 })
        
        guard invalidAmounts.isEmpty else {
            completion(.failure(error: .invalidDestinationAmount))
            return
        }
        
        guard destinations.isEmpty == false else {
            completion(.failure(error: .destinationEmpty))
            return
        }
        
        let paymentExtraField = parse(paymentId: paymentId)
        
        //let neededMoney = destinations.map({ $0.amount }).reduce(0, +) + fee

        // TODO: Get balance for wallet and check if there's enough money
        
        // TODO: If mixin == 0, add dust (TODO: WTF is dust and how do I handle it)

        // TODO: Handle mixin
        
        // TODO: Get transaction, increment ID
        
        /*struct SendTransactionContext
        {
            TransactionId transactionId;
            std::vector<CryptoNote::COMMAND_RPC_GET_RANDOM_OUTPUTS_FOR_AMOUNTS::outs_for_amount> outs;
            uint64_t foundMoney;
            std::list<TransactionOutputInformation> selectedTransfers;
            TxDustPolicy dustPolicy;
            uint64_t mixIn;
        };*/
        
        /*
        uint64_t WalletTransactionSender::selectTransfersToSend(uint64_t neededMoney, bool addDust, uint64_t dust, std::list<TransactionOutputInformation>& selectedTransfers) {
            
            std::vector<size_t> unusedTransfers;
            std::vector<size_t> unusedDust;
            
            std::vector<TransactionOutputInformation> outputs;
            m_transferDetails.getOutputs(outputs, ITransfersContainer::IncludeKeyUnlocked);
            
            for (size_t i = 0; i < outputs.size(); ++i) {
                const auto& out = outputs[i];
                if (!m_transactionsCache.isUsed(out)) {
                    if (dust < out.amount)
                    unusedTransfers.push_back(i);
                    else
                    unusedDust.push_back(i);
                }
            }
            
            std::default_random_engine randomGenerator(Crypto::rand<std::default_random_engine::result_type>());
            bool selectOneDust = addDust && !unusedDust.empty();
            uint64_t foundMoney = 0;
            
            while (foundMoney < neededMoney && (!unusedTransfers.empty() || !unusedDust.empty())) {
                size_t idx;
                if (selectOneDust) {
                    idx = popRandomValue(randomGenerator, unusedDust);
                    selectOneDust = false;
                } else {
                    idx = !unusedTransfers.empty() ? popRandomValue(randomGenerator, unusedTransfers) : popRandomValue(randomGenerator, unusedDust);
                }
                
                selectedTransfers.push_back(outputs[idx]);
                foundMoney += outputs[idx].amount;
            }
            
            return foundMoney;
            
        }*/
        
        // TODO: Prepare inputs
        
        /*void WalletTransactionSender::prepareInputs(
        const std::list<TransactionOutputInformation>& selectedTransfers,
        std::vector<COMMAND_RPC_GET_RANDOM_OUTPUTS_FOR_AMOUNTS::outs_for_amount>& outs,
        std::vector<TransactionSourceEntry>& sources, uint64_t mixIn) {
            
            size_t i = 0;
            
            for (const auto& td: selectedTransfers) {
                sources.resize(sources.size()+1);
                TransactionSourceEntry& src = sources.back();
                
                src.amount = td.amount;
                
                //paste mixin transaction
                if(outs.size()) {
                    std::sort(outs[i].outs.begin(), outs[i].outs.end(),
                    [](const COMMAND_RPC_GET_RANDOM_OUTPUTS_FOR_AMOUNTS::out_entry& a, const COMMAND_RPC_GET_RANDOM_OUTPUTS_FOR_AMOUNTS::out_entry& b){return a.global_amount_index < b.global_amount_index;});
                    for (auto& daemon_oe: outs[i].outs) {
                        if(td.globalOutputIndex == daemon_oe.global_amount_index)
                        continue;
                        TransactionSourceEntry::OutputEntry oe;
                        oe.first = static_cast<uint32_t>(daemon_oe.global_amount_index);
                        oe.second = daemon_oe.out_key;
                        src.outputs.push_back(oe);
                        if(src.outputs.size() >= mixIn)
                        break;
                    }
                }
                
                //paste real transaction to the random index
                auto it_to_insert = std::find_if(src.outputs.begin(), src.outputs.end(), [&](const TransactionSourceEntry::OutputEntry& a) { return a.first >= td.globalOutputIndex; });
                
                TransactionSourceEntry::OutputEntry real_oe;
                real_oe.first = td.globalOutputIndex;
                real_oe.second = td.outputKey;
                
                auto interted_it = src.outputs.insert(it_to_insert, real_oe);
                
                src.realTransactionPublicKey = td.transactionPublicKey;
                src.realOutput = interted_it - src.outputs.begin();
                src.realOutputIndexInTransaction = td.outputInTransaction;
                ++i;
            }
        }*/
    }
    
    func parse(paymentId: String?) -> TransactionExtraField? {
        guard let paymentId = paymentId else { return nil }
        
        return TransactionExtraField(data: paymentId.toBytes, tag: Constants.transactionExtraPaymentId)
    }

}
