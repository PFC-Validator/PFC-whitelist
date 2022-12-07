#!/usr/bin/env bash

export init='
{
  "create_pair": {
    "pair_type": {
      "stable": {}
    },
    "asset_infos": [
      {
        "token": {
          "contract_addr": "terra1xztnx8mm7dagn4ck3dgylaqucp6h6agw83pmyc29hnplq7355trs78fkcq"
        }
      },
      {
        "native_token": {
          "denom": "uluna"
        }
      }
    ],
    "init_params":"eyJhbXAiOjEwfQ=="
  }
}'
export factory="terra14x9fr055x5hvr48hzy2t4q7kvjvfttsvxusa4xsdcy702mnzsvuqprer8r"

# Pair
#export contract="terra1v2ycfsv427m28tn32gjllza4p6hpe65excyxgtuszkycp73fjams85598j"
export steak_token="terra17aj4ty4sz4yhgm08na8drc0v03v2jwr3waxcqrwhajj729zhl7zqnpc0ml"

export factory_query='{
     "pair": {
       "asset_infos": [
           {
             "token": {
               "contract_addr": "terra17aj4ty4sz4yhgm08na8drc0v03v2jwr3waxcqrwhajj729zhl7zqnpc0ml"
           }
           },
           {
             "native_token": {
               "denom": "uluna"
           }
         }
       ]
     }
   }'

terrad query wasm cs smart $factory "${factory_query}"
export pair="terra1h32epkd72x7st0wk49z35qlpsxf26pw4ydacs8acq6uka7hgshmq7z7vl9"
export lp_token="terra1h3z2zv6aw94fx5263dy6tgz6699kxmewlx3vrcu4jjrudg6xmtyqk6vt0u"
export lp_contract=$pair
export generator="terra1ksvlfex49desf4c452j6dewdjs6c48nafemetuwjyj6yexd7x3wqvwa7j9"

# provide liquidity to LP (not run)

terrad tx wasm exec $steak_token '
{  "increase_allowance": { "amount": "1000000",
    "spender": "terra1v2ycfsv427m28tn32gjllza4p6hpe65excyxgtuszkycp73fjams85598j" }}'  --from testadmin --fees 30000uluna


terrad tx wasm exec $lp_contract '
{
  "provide_liquidity": {
    "assets": [
      {
        "amount": "1000000",
        "info": {
          "token": {
            "contract_addr": "terra1xztnx8mm7dagn4ck3dgylaqucp6h6agw83pmyc29hnplq7355trs78fkcq"
          }
        }
      },
      {
        "amount": "1000000",
        "info": {
          "native_token": {
            "denom": "uluna"
          }
        }
      }
    ],
    "auto_stake": false,
    "slippage_tolerance": "0.02"
  }
}'  --from testadmin --fees 30000uluna --amount 10000000uluna --gas 1000000

terrad query wasm cs smart $generator '{"config":{}}'|jq -e .data.allowed_reward_proxies


#export reward_contract="terra10jmdvgf5tk5j3yq8c8jynxzj2ghf73sjy8l6xr85zclqpmkeyhpq6q2e36"
export astro_contract="terra17re5g6mrp6upu9prhg35r9y7ugagkxm9kuxpypf2gqya2wnvtg8sdfs8p8"

export msg = {
   "set_allowed_reward_proxies": {
       "proxies": [
                    "terra14ewvq39vg23j0hcesecv6hkzkwkvrnuxzd5sddmry9lx6qrhaxcqjdx6er",
                    "terra15yuq64lp74df0d5pdcmwzep80j0aa4hs3fktqyupz4a82ayvdw2s4rdykv",
                    "terra17re5g6mrp6upu9prhg35r9y7ugagkxm9kuxpypf2gqya2wnvtg8sdfs8p8"
                  ]
   }
}
# XXX
export binmsg1='ewogICAic2V0X2FsbG93ZWRfcmV3YXJkX3Byb3hpZXMiOiB7CiAgICAgICAicHJveGllcyI6IFsKICAgICAgICAgICAgICAgICAgICAidGVycmExdzI1eWd2dDk3Nm5oNjU3djA2aDBjc240N2E1Nng1bnd6dDUweGx3NHh1OHNwcjg4YTA4cWhuOTlweSIsCiAgICAgICAgICAgICAgICAgICAgInRlcnJhMXkzcGpuNmcwYXd6cGttZTJuZnA0bnp1NzVhZTZ3dWhkZnp0ZG4ycHFqdTV0bHpoa3BoanE1c3QydHMiLAogICAgICAgICAgICAgICAgICAgICJ0ZXJyYTEwZjRrbnZocGMwZ3Z1bm5kNDh3cW43cjVkNWNlMmt4Zm53eXNuMHVxbndxY3Y3dTdhNHFzMmFrOHZnIgogICAgICAgICAgICAgICAgICBdCiAgIH0KfQ=='


export allow_proxies_msg = '{
   order: "1",
   "msg": {
       "wasm": {
           "execute": {
               "contract_addr": "terra1gc4d4v82vjgkz0ag28lrmlxx3tf6sq69tmaujjpe7jwmnqakkx0qm28j2l",
               "msg": "ewogICAic2V0X2FsbG93ZWRfcmV3YXJkX3Byb3hpZXMiOiB7CiAgICAgICAicHJveGllcyI6IFsKICAgICAgICAgICAgICAgICAgICAidGVycmExdzI1eWd2dDk3Nm5oNjU3djA2aDBjc240N2E1Nng1bnd6dDUweGx3NHh1OHNwcjg4YTA4cWhuOTlweSIsCiAgICAgICAgICAgICAgICAgICAgInRlcnJhMXkzcGpuNmcwYXd6cGttZTJuZnA0bnp1NzVhZTZ3dWhkZnp0ZG4ycHFqdTV0bHpoa3BoanE1c3QydHMiLAogICAgICAgICAgICAgICAgICAgICJ0ZXJyYTEwZjRrbnZocGMwZ3Z1bm5kNDh3cW43cjVkNWNlMmt4Zm53eXNuMHVxbndxY3Y3dTdhNHFzMmFrOHZnIgogICAgICAgICAgICAgICAgICBdCiAgIH0KfQ==",
               "funds": []
           }
       }
   }
}'
export msg2 = '{
   "move_to_proxy": {
       "lp_token": "terra1mqmrh89e42yk6vy026mawymz879d4p829560krcql3e0ws23lassk6hzx4",
       "proxy": "terra10f4knvhpc0gvunnd48wqn7r5d5ce2kxfnwysn0uqnwqcv7u7a4qs2ak8vg"
   }
}'
export binmsg2='ewogICAibW92ZV90b19wcm94eSI6IHsKICAgICAgICJscF90b2tlbiI6ICJ0ZXJyYTFtcW1yaDg5ZTQyeWs2dnkwMjZtYXd5bXo4NzlkNHA4Mjk1NjBrcmNxbDNlMHdzMjNsYXNzazZoeng0IiwKICAgICAgICJwcm94eSI6ICJ0ZXJyYTEwZjRrbnZocGMwZ3Z1bm5kNDh3cW43cjVkNWNlMmt4Zm53eXNuMHVxbndxY3Y3dTdhNHFzMmFrOHZnIgogICB9Cn0='
export allow_proxies_msg = '{
   "order": "2",
   "msg": {
       "wasm": {
           "execute": {
               "contract_addr": "terra1gc4d4v82vjgkz0ag28lrmlxx3tf6sq69tmaujjpe7jwmnqakkx0qm28j2l",
               "msg": "ewogICAibW92ZV90b19wcm94eSI6IHsKICAgICAgICJscF90b2tlbiI6ICJ0ZXJyYTFtcW1yaDg5ZTQyeWs2dnkwMjZtYXd5bXo4NzlkNHA4Mjk1NjBrcmNxbDNlMHdzMjNsYXNzazZoeng0IiwKICAgICAgICJwcm94eSI6ICJ0ZXJyYTEwZjRrbnZocGMwZ3Z1bm5kNDh3cW43cjVkNWNlMmt4Zm53eXNuMHVxbndxY3Y3dTdhNHFzMmFrOHZnIgogICB9Cn0=",
               "funds": []
           }
       }
   }
}'
export  proposal_msg = '{
  "submit_proposal": {
  "title": "bLuna Rewards",
  "description": "bluna/luna rewards",
  "link": null,
  "messages": [{
            "order": "1",
            "msg": {
                "wasm": {
                    "execute": {
                        "contract_addr": "terra1gc4d4v82vjgkz0ag28lrmlxx3tf6sq69tmaujjpe7jwmnqakkx0qm28j2l",
                        "msg": "ewogICAic2V0X2FsbG93ZWRfcmV3YXJkX3Byb3hpZXMiOiB7CiAgICAgICAicHJveGllcyI6IFsKICAgICAgICAgICAgICAgICAgICAidGVycmExdzI1eWd2dDk3Nm5oNjU3djA2aDBjc240N2E1Nng1bnd6dDUweGx3NHh1OHNwcjg4YTA4cWhuOTlweSIsCiAgICAgICAgICAgICAgICAgICAgInRlcnJhMXkzcGpuNmcwYXd6cGttZTJuZnA0bnp1NzVhZTZ3dWhkZnp0ZG4ycHFqdTV0bHpoa3BoanE1c3QydHMiLAogICAgICAgICAgICAgICAgICAgICJ0ZXJyYTEwZjRrbnZocGMwZ3Z1bm5kNDh3cW43cjVkNWNlMmt4Zm53eXNuMHVxbndxY3Y3dTdhNHFzMmFrOHZnIgogICAgICAgICAgICAgICAgICBdCiAgIH0KfQ",
                        "funds": []
                    }
                }
            }
         }, {
               "order": "2",
               "msg": {
                   "wasm": {
                       "execute": {
                           "contract_addr": "terra1gc4d4v82vjgkz0ag28lrmlxx3tf6sq69tmaujjpe7jwmnqakkx0qm28j2l",
                           "msg": "ewogICAibW92ZV90b19wcm94eSI6IHsKICAgICAgICJscF90b2tlbiI6ICJ0ZXJyYTFtcW1yaDg5ZTQyeWs2dnkwMjZtYXd5bXo4NzlkNHA4Mjk1NjBrcmNxbDNlMHdzMjNsYXNzazZoeng0IiwKICAgICAgICJwcm94eSI6ICJ0ZXJyYTEwZjRrbnZocGMwZ3Z1bm5kNDh3cW43cjVkNWNlMmt4Zm53eXNuMHVxbndxY3Y3dTdhNHFzMmFrOHZnIgogICB9Cn0",
                           "funds": []
                       }
                   }
               }
            }]
  }
}'
export check='{"check_messages":{
 "messages": [{
            "order": "1",
            "msg": {
                "wasm": {
                    "execute": {
                        "contract_addr": "terra1gc4d4v82vjgkz0ag28lrmlxx3tf6sq69tmaujjpe7jwmnqakkx0qm28j2l",
                        "msg": "ewogICAic2V0X2FsbG93ZWRfcmV3YXJkX3Byb3hpZXMiOiB7CiAgICAgICAicHJveGllcyI6IFsKICAgICAgICAgICAgICAgICAgICAidGVycmExdzI1eWd2dDk3Nm5oNjU3djA2aDBjc240N2E1Nng1bnd6dDUweGx3NHh1OHNwcjg4YTA4cWhuOTlweSIsCiAgICAgICAgICAgICAgICAgICAgInRlcnJhMXkzcGpuNmcwYXd6cGttZTJuZnA0bnp1NzVhZTZ3dWhkZnp0ZG4ycHFqdTV0bHpoa3BoanE1c3QydHMiLAogICAgICAgICAgICAgICAgICAgICJ0ZXJyYTEwZjRrbnZocGMwZ3Z1bm5kNDh3cW43cjVkNWNlMmt4Zm53eXNuMHVxbndxY3Y3dTdhNHFzMmFrOHZnIgogICAgICAgICAgICAgICAgICBdCiAgIH0KfQ",
                        "funds": []
                    }
                }
            }
         }, {
               "order": "2",
               "msg": {
                   "wasm": {
                       "execute": {
                           "contract_addr": "terra1gc4d4v82vjgkz0ag28lrmlxx3tf6sq69tmaujjpe7jwmnqakkx0qm28j2l",
                           "msg": "ewogICAibW92ZV90b19wcm94eSI6IHsKICAgICAgICJscF90b2tlbiI6ICJ0ZXJyYTFtcW1yaDg5ZTQyeWs2dnkwMjZtYXd5bXo4NzlkNHA4Mjk1NjBrcmNxbDNlMHdzMjNsYXNzazZoeng0IiwKICAgICAgICJwcm94eSI6ICJ0ZXJyYTEwZjRrbnZocGMwZ3Z1bm5kNDh3cW43cjVkNWNlMmt4Zm53eXNuMHVxbndxY3Y3dTdhNHFzMmFrOHZnIgogICB9Cn0",
                           "funds": []
                       }
                   }
               }
            }]
}}'


export bin_prop_msg='ewogICJzdWJtaXRfcHJvcG9zYWwiOiB7CiAgInRpdGxlIjogImJMdW5hIFJld2FyZHMiLAogICJkZXNjcmlwdGlvbiI6ICJibHVuYS9sdW5hIHJld2FyZHMiLAogICJsaW5rIjogbnVsbCwKICAibWVzc2FnZXMiOiBbewogICAgICAgICAgICAib3JkZXIiOiAiMSIsCiAgICAgICAgICAgICJtc2ciOiB7CiAgICAgICAgICAgICAgICAid2FzbSI6IHsKICAgICAgICAgICAgICAgICAgICAiZXhlY3V0ZSI6IHsKICAgICAgICAgICAgICAgICAgICAgICAgImNvbnRyYWN0X2FkZHIiOiAidGVycmExZ2M0ZDR2ODJ2amdrejBhZzI4bHJtbHh4M3RmNnNxNjl0bWF1ampwZTdqd21ucWFra3gwcW0yOGoybCIsCiAgICAgICAgICAgICAgICAgICAgICAgICJtc2ciOiAiZXdvZ0lDQWljMlYwWDJGc2JHOTNaV1JmY21WM1lYSmtYM0J5YjNocFpYTWlPaUI3Q2lBZ0lDQWdJQ0FpY0hKdmVHbGxjeUk2SUZzS0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWlkR1Z5Y21FeGR6STFlV2QyZERrM05tNW9OalUzZGpBMmFEQmpjMjQwTjJFMU5uZzFibmQ2ZERVd2VHeDNOSGgxT0hOd2NqZzRZVEE0Y1dodU9UbHdlU0lzQ2lBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0luUmxjbkpoTVhremNHcHVObWN3WVhkNmNHdHRaVEp1Wm5BMGJucDFOelZoWlRaM2RXaGtabnAwWkc0eWNIRnFkVFYwYkhwb2EzQm9hbkUxYzNReWRITWlMQW9nSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNKMFpYSnlZVEV3YW0xa2RtZG1OWFJyTldvemVYRTRZemhxZVc1NGVtb3laMmhtTnpOemFuazRiRFo0Y2pnMWVtTnNjWEJ0YTJWNWFIQnhObkV5WlRNMklnb2dJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQmRDaUFnSUgwS2ZRIiwKICAgICAgICAgICAgICAgICAgICAgICAgImZ1bmRzIjogW10KICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICAgfSwgewogICAgICAgICAgICAgICAib3JkZXIiOiAiMiIsCiAgICAgICAgICAgICAgICJtc2ciOiB7CiAgICAgICAgICAgICAgICAgICAid2FzbSI6IHsKICAgICAgICAgICAgICAgICAgICAgICAiZXhlY3V0ZSI6IHsKICAgICAgICAgICAgICAgICAgICAgICAgICAgImNvbnRyYWN0X2FkZHIiOiAidGVycmExZ2M0ZDR2ODJ2amdrejBhZzI4bHJtbHh4M3RmNnNxNjl0bWF1ampwZTdqd21ucWFra3gwcW0yOGoybCIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICJtc2ciOiAiZXdvZ0lDQWliVzkyWlY5MGIxOXdjbTk0ZVNJNklIc0tJQ0FnSUNBZ0lDSnNjRjkwYjJ0bGJpSTZJQ0owWlhKeVlURnRjVzF5YURnNVpUUXllV3MyZG5rd01qWnRZWGQ1YlhvNE56bGtOSEE0TWprMU5qQnJjbU54YkRObE1IZHpNak5zWVhOemF6Wm9lbmcwSWl3S0lDQWdJQ0FnSUNKd2NtOTRlU0k2SUNKMFpYSnlZVEV3YW0xa2RtZG1OWFJyTldvemVYRTRZemhxZVc1NGVtb3laMmhtTnpOemFuazRiRFo0Y2pnMWVtTnNjWEJ0YTJWNWFIQnhObkV5WlRNMklpd0tJQ0FnZlFwOSIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICJmdW5kcyI6IFtdCiAgICAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH1dCiAgfQp9'
export proposal_contract='terra195m6n5xq4rkjy47fn5y3s08tfmj3ryknj55jqvgq2y55zul9myzsgy06hk'


export vote='{"cast_vote": { "proposal_id": 86, "vote": "for"  }}'