import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

type ValidatePurchaseRequest = {
  platform?: 'android' | 'ios';
  product_id?: string;
  transaction_id?: string;
  purchase_token?: string;
};

const jsonHeaders = {
  'Content-Type': 'application/json',
};

Deno.serve(async (request) => {
  if (request.method !== 'POST') {
    return new Response(
      JSON.stringify({ error: 'Method not allowed' }),
      { status: 405, headers: jsonHeaders },
    );
  }

  const authHeader = request.headers.get('Authorization') ?? '';
  const token = authHeader.replace('Bearer ', '').trim();
  if (!token) {
    return new Response(
      JSON.stringify({ error: 'Missing authenticated user token' }),
      { status: 401, headers: jsonHeaders },
    );
  }

  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY');
  if (!supabaseUrl || !supabaseAnonKey) {
    return new Response(
      JSON.stringify({ error: 'Function environment is not configured' }),
      { status: 500, headers: jsonHeaders },
    );
  }

  const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    global: { headers: { Authorization: `Bearer ${token}` } },
  });

  const { data, error } = await supabase.auth.getUser(token);
  if (error || !data.user) {
    return new Response(
      JSON.stringify({ error: 'Invalid authenticated user token' }),
      { status: 401, headers: jsonHeaders },
    );
  }

  const body = (await request.json().catch(() => ({}))) as ValidatePurchaseRequest;
  const requiredFields = [
    body.platform,
    body.product_id,
    body.transaction_id,
    body.purchase_token,
  ];
  if (requiredFields.some((value) => !value)) {
    return new Response(
      JSON.stringify({
        error:
          'platform, product_id, transaction_id and purchase_token are required',
      }),
      { status: 400, headers: jsonHeaders },
    );
  }

  const allowDevValidation =
    Deno.env.get('ALLOW_DEV_PURCHASE_VALIDATION') === 'true';

  if (!allowDevValidation) {
    return new Response(
      JSON.stringify({
        valid: false,
        environment: 'production_guard',
        message:
          'Purchase validation is not enabled. Configure Google/Apple validation before granting entitlements.',
      }),
      { status: 200, headers: jsonHeaders },
    );
  }

  return new Response(
    JSON.stringify({
      valid: true,
      environment: 'dev_only',
      user_id: data.user.id,
      product_id: body.product_id,
      platform: body.platform,
      message:
        'Dev validation accepted. This function does not grant premium or credits yet.',
    }),
    { status: 200, headers: jsonHeaders },
  );
});
