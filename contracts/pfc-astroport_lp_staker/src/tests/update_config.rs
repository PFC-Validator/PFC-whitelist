use cosmwasm_std::testing::mock_info;
use cosmwasm_std::{Addr, Env, MessageInfo, Response, Uint128};
use pfc_astroport_lp_staking::errors::ContractError;

use crate::executions::update_config;
use crate::states::Config;
use pfc_astroport_lp_staking::mock_querier::{custom_deps, CustomDeps};
use pfc_astroport_lp_staking::test_constants::liquidity::*;
use pfc_astroport_lp_staking::test_constants::DEFAULT_SENDER;
use pfc_astroport_lp_staking::test_utils::{expect_generic_err, expect_unauthorized_err};

use crate::tests::instantiate::default;

pub fn exec(
    deps: &mut CustomDeps,
    env: Env,
    info: MessageInfo,
    token: Option<String>,
    pair: Option<String>,
    lp_token: Option<String>,
    admin: Option<String>,
    whitelisted_contracts: Option<Vec<String>>,
) -> Result<Response, ContractError> {
    update_config(
        deps.as_mut(),
        env,
        info,
        token,
        pair,
        lp_token,
        admin,
        whitelisted_contracts,
    )
}

pub fn will_success(
    deps: &mut CustomDeps,
    token: Option<String>,
    pair: Option<String>,
    lp_token: Option<String>,
    admin: Option<String>,
    whitelisted_contracts: Option<Vec<String>>,
    distribution_schedule: Option<Vec<(u64, u64, Uint128)>>,
) -> (Env, MessageInfo, Response) {
    let env = lp_env();
    let info = mock_info(DEFAULT_SENDER, &[]);

    let response = exec(
        deps,
        env.clone(),
        info.clone(),
        token,
        pair,
        lp_token,
        admin,
        whitelisted_contracts,
        distribution_schedule,
    )
    .unwrap();

    (env, info, response)
}

#[test]
fn succeed() {
    let mut deps = custom_deps();

    let (_env, info, _response) = default(&mut deps, None);

    let whitelisted_contracts = vec![
        "terra1r4qtnusnk63wkg2y6sytwr37aymz0sfy3p2yc9".to_string(),
        "terra14mtctaszgzm4gcedlfslds802fmklnp4up72da".to_string(),
    ];
    let distribution_schedule = vec![
        (0, 50, Uint128::new(50u128)),
        (50, 100, Uint128::new(50u128)),
    ];

    will_success(
        &mut deps,
        Some("terra1r0rm0evrlkfvpt0csrcpmnpmrega54czajfd86".to_string()),
        Some("terra1fmcjjt6yc9wqup2r06urnrd928jhrde6gcld6n".to_string()),
        Some("terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r".to_string()),
        Some("terra1e8ryd9ezefuucd4mje33zdms9m2s90m57878v9".to_string()),
        Some(whitelisted_contracts.clone()),
        Some(distribution_schedule.clone()),
    );

    let config = Config::load(&deps.storage).unwrap();
    assert_eq!(
        config.token,
        Addr::unchecked("terra1r0rm0evrlkfvpt0csrcpmnpmrega54czajfd86".to_string())
    );
    assert_eq!(
        config.pair,
        Addr::unchecked("terra1fmcjjt6yc9wqup2r06urnrd928jhrde6gcld6n".to_string())
    );
    assert_eq!(
        config.lp_token,
        Addr::unchecked("terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r".to_string())
    );
    assert_eq!(config.admin, info.sender);
    assert_eq!(config.whitelisted_contracts, whitelisted_contracts);

    let admin_nominee = Config::may_load_admin_nominee(&deps.storage).unwrap();
    assert_eq!(
        admin_nominee,
        Some(Addr::unchecked(
            "terra1e8ryd9ezefuucd4mje33zdms9m2s90m57878v9".to_string()
        ))
    );
}

#[test]
fn failed_invalid_permission() {
    let mut deps = custom_deps();

    let (env, mut info, _response) = default(&mut deps, None);

    info.sender = Addr::unchecked("terra1e8ryd9ezefuucd4mje33zdms9m2s90m57878v9");

    let result = exec(&mut deps, env, info, None, None, None, None, None, None);

    expect_unauthorized_err(&result);
}
