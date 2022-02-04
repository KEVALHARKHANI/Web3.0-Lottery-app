from brownie import Lottery,network,accounts,config

def lottery_app():
    account = accounts[0]
    lottery = Lottery.deploy(config['networks'][network.show_active()]["eth_usd_price_feed"],{"from":account})


def start_lotter():
    tx = Lottery[-1].startLottery({"from":accounts[0]})
    tx.wait(1)

def enter_lottery():
    tx = Lottery[-1].enter({"from":accounts[0]})
    tx.wait(1)
def end_lottery():
    tx = Lottery[-1].endLottery({"from":accounts[0]})
    tx.wait(1)



def main():
    lottery_app()
    start_lotter()
    enter_lottery()
    end_lottery()
