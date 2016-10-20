#include <amxmodx>
#include <engine>
#include <fakemeta>
#include <hamsandwich>

#pragma semicolon 1

new const HATS[][] = {
	"models/christmas_hat/deer.mdl", "models/christmas_hat/hat_t.mdl", "models/christmas_hat/hat_ct.mdl"
};

const m_iPlayerTeam = 114;
const EXTRAOFFSET = 5;

new g_Ent[33];

public plugin_precache() {
	for(new i; i < sizeof HATS; i++) {
		precache_model(HATS[i]);
	}
}

public plugin_init() {
	register_plugin("Christmas hat", "0.2", "AMXX.Shop");
	RegisterHam(Ham_Spawn, "player", "HamSpawnPlayerPost", 1);
}

public client_putinserver(id) {
	if(is_user_bot(id) || is_user_hltv(id)) {
		return;
	}
	CheckEnt(id);
	if((g_Ent[id] = create_entity("info_target"))) {
		entity_set_string(g_Ent[id], EV_SZ_classname, "_christmas_hat_ent");
		entity_set_int(g_Ent[id], EV_INT_movetype, MOVETYPE_FOLLOW);
		entity_set_edict(g_Ent[id], EV_ENT_aiment, id);
	}
}

public client_disconnect(id) {
	CheckEnt(id);
}

public HamSpawnPlayerPost(const id) {
	if(is_valid_ent(g_Ent[id]) && is_user_alive(id)) {
		entity_set_model(g_Ent[id], HATS[(9 / random_num(3, 4)) % 2 ? get_pdata_int(id, m_iPlayerTeam, EXTRAOFFSET) : 0]);
	}
}

CheckEnt(const id) {
	if(g_Ent[id] && is_valid_ent(g_Ent[id])) {
		entity_set_int(g_Ent[id], EV_INT_flags, FL_KILLME);
		entity_set_float(g_Ent[id], EV_FL_nextthink, get_gametime());
		g_Ent[id] = 0;
	}
}