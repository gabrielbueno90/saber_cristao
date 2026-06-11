-- Correcoes textuais seguras para perguntas pt-BR
-- Aplicar apos v1/v2/v4 seeds
-- Escopo: question_text e explanation na tabela public.questions

-- Validacao antes
-- select id, language, category, difficulty, level, question_text, explanation, bible_reference
-- from public.questions
-- where language = 'pt-BR'
--   and is_active = true
-- order by level, difficulty, id;
--
-- select id, language, category, difficulty, level, question_text, explanation, bible_reference
-- from public.questions
-- where language = 'pt-BR'
--   and question_text ilike '%por recebeu%';

begin;

update public.questions
set question_text = case question_text
  when 'Quem é lembrado por construiu a arca por ordem de Deus?' then 'Quem é lembrado por ter construído a arca por ordem de Deus?'
  when 'Que personagem bíblico ficou conhecido por construiu a arca por ordem de Deus?' then 'Que personagem bíblico ficou conhecido por ter construído a arca por ordem de Deus?'
  when 'Quem é lembrado por foi chamado para deixar sua terra e confiar na promessa divina?' then 'Quem é lembrado por ter sido chamado para deixar sua terra e confiar na promessa divina?'
  when 'Que personagem bíblico ficou conhecido por foi chamado para deixar sua terra e confiar na promessa divina?' then 'Que personagem bíblico ficou conhecido por ter sido chamado para deixar sua terra e confiar na promessa divina?'
  when 'Quem é lembrado por foi usado por Deus para tirar Israel do Egito?' then 'Quem é lembrado por ter sido usado por Deus para tirar Israel do Egito?'
  when 'Que personagem bíblico ficou conhecido por foi usado por Deus para tirar Israel do Egito?' then 'Que personagem bíblico ficou conhecido por ter sido usado por Deus para tirar Israel do Egito?'
  when 'Quem é lembrado por foi escolhido como rei e escreveu muitos salmos?' then 'Quem é lembrado por ter sido escolhido como rei e por ter escrito muitos salmos?'
  when 'Que personagem bíblico ficou conhecido por foi escolhido como rei e escreveu muitos salmos?' then 'Que personagem bíblico ficou conhecido por ter sido escolhido como rei e por ter escrito muitos salmos?'
  when 'Quem é lembrado por promoveu uma reforma ao ouvir o Livro da Lei?' then 'Quem é lembrado por ter promovido uma reforma ao ouvir o Livro da Lei?'
  when 'Que personagem bíblico ficou conhecido por promoveu uma reforma ao ouvir o Livro da Lei?' then 'Que personagem bíblico ficou conhecido por ter promovido uma reforma ao ouvir o Livro da Lei?'
  when 'Quem é lembrado por escreveu o livro de Atos dos Apóstolos?' then 'Quem é lembrado por ter escrito o livro de Atos dos Apóstolos?'
  when 'Que personagem bíblico ficou conhecido por escreveu o livro de Atos dos Apóstolos?' then 'Que personagem bíblico ficou conhecido por ter escrito o livro de Atos dos Apóstolos?'
  when 'Quem é lembrado por foi o primeiro mártir cristão em Atos?' then 'Quem é lembrado por ter sido o primeiro mártir cristão em Atos?'
  when 'Que personagem bíblico ficou conhecido por foi o primeiro mártir cristão em Atos?' then 'Que personagem bíblico ficou conhecido por ter sido o primeiro mártir cristão em Atos?'
  when 'Quem é lembrado por teve o coração aberto pelo Senhor em Filipos?' then 'Quem é lembrado por ter tido o coração aberto pelo Senhor em Filipos?'
  when 'Que personagem bíblico ficou conhecido por teve o coração aberto pelo Senhor em Filipos?' then 'Que personagem bíblico ficou conhecido por ter tido o coração aberto pelo Senhor em Filipos?'
  when 'Quem é lembrado por foi chamado para ser apóstolo dos gentios?' then 'Quem é lembrado por ter sido chamado para ser apóstolo dos gentios?'
  when 'Que personagem bíblico ficou conhecido por foi chamado para ser apóstolo dos gentios?' then 'Que personagem bíblico ficou conhecido por ter sido chamado para ser apóstolo dos gentios?'
  when 'Quem é lembrado por recebeu cartas pastorais para cuidar da igreja?' then 'Quem recebeu cartas pastorais com orientações para cuidar da igreja?'
  when 'Que personagem bíblico ficou conhecido por recebeu cartas pastorais para cuidar da igreja?' then 'Que personagem bíblico ficou conhecido por ter recebido cartas pastorais com orientações para cuidar da igreja?'
  when 'Quem é lembrado por nasceu em Belém para cumprir a promessa messiânica?' then 'Quem é lembrado por ter nascido em Belém para cumprir a promessa messiânica?'
  when 'Que personagem bíblico ficou conhecido por nasceu em Belém para cumprir a promessa messiânica?' then 'Que personagem bíblico ficou conhecido por ter nascido em Belém para cumprir a promessa messiânica?'
  when 'Quem é lembrado por foi batizado por João Batista no rio Jordão?' then 'Quem é lembrado por ter sido batizado por João Batista no rio Jordão?'
  when 'Que personagem bíblico ficou conhecido por foi batizado por João Batista no rio Jordão?' then 'Que personagem bíblico ficou conhecido por ter sido batizado por João Batista no rio Jordão?'
  when 'Quem é lembrado por transformou água em vinho em Caná?' then 'Quem é lembrado por ter transformado água em vinho em Caná?'
  when 'Que personagem bíblico ficou conhecido por transformou água em vinho em Caná?' then 'Que personagem bíblico ficou conhecido por ter transformado água em vinho em Caná?'
  when 'Quem é lembrado por acalmou a tempestade no mar?' then 'Quem é lembrado por ter acalmado a tempestade no mar?'
  when 'Que personagem bíblico ficou conhecido por acalmou a tempestade no mar?' then 'Que personagem bíblico ficou conhecido por ter acalmado a tempestade no mar?'
  when 'Quem é lembrado por ressuscitou Lázaro em Betânia?' then 'Quem é lembrado por ter ressuscitado Lázaro em Betânia?'
  when 'Que personagem bíblico ficou conhecido por ressuscitou Lázaro em Betânia?' then 'Que personagem bíblico ficou conhecido por ter ressuscitado Lázaro em Betânia?'
  when 'Quem é lembrado por construiu a arca por obediência a Deus?' then 'Quem é lembrado por ter construído a arca por obediência a Deus?'
  when 'Que personagem bíblico ficou conhecido por construiu a arca por obediência a Deus?' then 'Que personagem bíblico ficou conhecido por ter construído a arca por obediência a Deus?'
  when 'Quem é lembrado por intercedeu pelo seu povo diante do rei?' then 'Quem é lembrado por ter intercedido pelo seu povo diante do rei?'
  when 'Que personagem bíblico ficou conhecido por intercedeu pelo seu povo diante do rei?' then 'Que personagem bíblico ficou conhecido por ter intercedido pelo seu povo diante do rei?'
  when 'Quem é lembrado por permaneceu fiel e orava ao Senhor mesmo sob decreto?' then 'Quem é lembrado por ter permanecido fiel e por orar ao Senhor mesmo sob decreto?'
  when 'Que personagem bíblico ficou conhecido por permaneceu fiel e orava ao Senhor mesmo sob decreto?' then 'Que personagem bíblico ficou conhecido por ter permanecido fiel e por orar ao Senhor mesmo sob decreto?'
  when 'Quem é lembrado por mostrou lealdade a Noemi?' then 'Quem é lembrado por ter demonstrado lealdade a Noemi?'
  when 'Que personagem bíblico ficou conhecido por mostrou lealdade a Noemi?' then 'Que personagem bíblico ficou conhecido por ter demonstrado lealdade a Noemi?'
  when 'Quem é lembrado por foi vendido pelos irmãos e depois governou o Egito?' then 'Quem é lembrado por ter sido vendido pelos irmãos e depois se tornado governador no Egito?'
  when 'Que personagem bíblico ficou conhecido por foi vendido pelos irmãos e depois governou o Egito?' then 'Que personagem bíblico ficou conhecido por ter sido vendido pelos irmãos e depois se tornado governador no Egito?'
  when 'Qual verdade bíblica a parábola do bom samaritano ensina amor misericordioso ao próximo?' then 'Qual parábola ensina o amor misericordioso ao próximo?'
  when 'Qual ensino cristão afirma que a parábola do bom samaritano ensina amor misericordioso ao próximo?' then 'Qual parábola destaca o amor misericordioso ao próximo?'
  when 'De forma mais precisa, o que a parábola do bom samaritano ensina amor misericordioso ao próximo?' then 'De forma mais precisa, qual parábola ensina o amor misericordioso ao próximo?'
  when 'Qual verdade bíblica a parábola do semeador mostra a recepção da Palavra em diferentes corações?' then 'Qual parábola mostra a recepção da Palavra em diferentes corações?'
  when 'Qual ensino cristão afirma que a parábola do semeador mostra a recepção da Palavra em diferentes corações?' then 'Qual parábola destaca a recepção da Palavra em diferentes corações?'
  when 'De forma mais precisa, o que a parábola do semeador mostra a recepção da Palavra em diferentes corações?' then 'De forma mais precisa, qual parábola mostra a recepção da Palavra em diferentes corações?'
  when 'Qual verdade bíblica a parábola do filho pródigo retrata graça ao arrependido?' then 'Qual parábola retrata a graça ao arrependido?'
  when 'Qual ensino cristão afirma que a parábola do filho pródigo retrata graça ao arrependido?' then 'Qual parábola destaca a graça ao arrependido?'
  when 'De forma mais precisa, o que a parábola do filho pródigo retrata graça ao arrependido?' then 'De forma mais precisa, qual parábola retrata a graça ao arrependido?'
  when 'Qual verdade bíblica a parábola dos talentos destaca fidelidade com o que Deus confia?' then 'Qual parábola destaca a fidelidade no uso do que Deus confia?'
  when 'Qual ensino cristão afirma que a parábola dos talentos destaca fidelidade com o que Deus confia?' then 'Qual parábola enfatiza a fidelidade no uso do que Deus confia?'
  when 'De forma mais precisa, o que a parábola dos talentos destaca fidelidade com o que Deus confia?' then 'De forma mais precisa, qual parábola destaca a fidelidade no uso do que Deus confia?'
  when 'Qual verdade bíblica a parábola do fariseu e do publicano mostra a humildade que busca misericórdia?' then 'Qual parábola mostra a humildade que busca misericórdia?'
  when 'Qual ensino cristão afirma que a parábola do fariseu e do publicano mostra a humildade que busca misericórdia?' then 'Qual parábola destaca a humildade que busca misericórdia?'
  when 'De forma mais precisa, o que a parábola do fariseu e do publicano mostra a humildade que busca misericórdia?' then 'De forma mais precisa, qual parábola mostra a humildade que busca misericórdia?'
  when 'Quantas pessoas há na Trindade, segundo a fé cristã histórica?' then 'Quantas pessoas há na Trindade, segundo a fé cristã histórica?'
  when 'De acordo com a Bíblia, quantas pessoas há na Trindade aponta principalmente para o que?' then 'Segundo a fé cristã histórica, quantas pessoas há na Trindade?'
  when 'De forma mais precisa, o que quantas pessoas há na Trindade?' then 'De forma mais precisa, quantas pessoas há na Trindade?'
  when 'Qual opção melhor resume que quantas pessoas há na Trindade?' then 'Qual opção resume corretamente quantas pessoas há na Trindade?'
  when 'Qual explicação melhor se encaixa quando como Deus declara justo o pecador em Cristo?' then 'Como chamamos o ato pelo qual Deus declara justo o pecador em Cristo?'
  when 'De acordo com a Bíblia, como Deus declara justo o pecador em Cristo aponta principalmente para o que?' then 'Segundo a Bíblia, como chamamos o ato pelo qual Deus declara justo o pecador em Cristo?'
  when 'De forma mais precisa, o que como Deus declara justo o pecador em Cristo?' then 'De forma mais precisa, como chamamos o ato pelo qual Deus declara justo o pecador em Cristo?'
  when 'Qual opção melhor resume que como Deus declara justo o pecador em Cristo?' then 'Qual opção resume corretamente como Deus declara justo o pecador em Cristo?'
  when 'Qual explicação melhor se encaixa quando como a santificação transforma a vida do crente?' then 'Como chamamos a obra pela qual Deus transforma a vida do crente?'
  when 'De acordo com a Bíblia, como a santificação transforma a vida do crente aponta principalmente para o que?' then 'Segundo a Bíblia, como chamamos a obra pela qual Deus transforma a vida do crente?'
  when 'De forma mais precisa, o que como a santificação transforma a vida do crente?' then 'De forma mais precisa, como chamamos a obra pela qual Deus transforma a vida do crente?'
  when 'Qual opção melhor resume que como a santificação transforma a vida do crente?' then 'Qual opção resume corretamente a obra pela qual Deus transforma a vida do crente?'
  when 'Qual explicação melhor se encaixa quando como a regeneração é obra do Espírito Santo que dá nova vida?' then 'Como chamamos a obra do Espírito Santo que dá nova vida ao pecador?'
  when 'De acordo com a Bíblia, como a regeneração é obra do Espírito Santo que dá nova vida aponta principalmente para o que?' then 'Segundo a Bíblia, como chamamos a obra do Espírito Santo que dá nova vida ao pecador?'
  when 'De forma mais precisa, o que como a regeneração é obra do Espírito Santo que dá nova vida?' then 'De forma mais precisa, como chamamos a obra do Espírito Santo que dá nova vida ao pecador?'
  when 'Qual opção melhor resume que como a regeneração é obra do Espírito Santo que dá nova vida?' then 'Qual opção resume corretamente a obra do Espírito Santo que dá nova vida ao pecador?'
  when 'Qual explicação melhor se encaixa quando como a perseverança dos santos depende do cuidado preservador de Deus?' then 'Como chamamos a doutrina segundo a qual os salvos perseveram pelo cuidado preservador de Deus?'
  when 'De acordo com a Bíblia, como a perseverança dos santos depende do cuidado preservador de Deus aponta principalmente para o que?' then 'Segundo a Bíblia, como chamamos a doutrina segundo a qual os salvos perseveram pelo cuidado preservador de Deus?'
  when 'De forma mais precisa, o que como a perseverança dos santos depende do cuidado preservador de Deus?' then 'De forma mais precisa, como chamamos a doutrina segundo a qual os salvos perseveram pelo cuidado preservador de Deus?'
  when 'Qual opção melhor resume que como a perseverança dos santos depende do cuidado preservador de Deus?' then 'Qual opção resume corretamente a doutrina segundo a qual os salvos perseveram pelo cuidado preservador de Deus?'
  when 'Qual explicação melhor se encaixa quando como a salvação é dom imerecido de Deus?' then 'Como chamamos o favor imerecido de Deus na salvação?'
  when 'De acordo com a Bíblia, como a salvação é dom imerecido de Deus aponta principalmente para o que?' then 'Segundo a Bíblia, como chamamos o favor imerecido de Deus na salvação?'
  when 'De forma mais precisa, o que como a salvação é dom imerecido de Deus?' then 'De forma mais precisa, como chamamos o favor imerecido de Deus na salvação?'
  when 'Qual opção melhor resume que como a salvação é dom imerecido de Deus?' then 'Qual opção resume corretamente o favor imerecido de Deus na salvação?'
  when 'Qual explicação melhor se encaixa quando como a fé salvadora descansa em Cristo e em sua obra?' then 'Como é descrita a fé salvadora segundo a Bíblia?'
  when 'De acordo com a Bíblia, como a fé salvadora descansa em Cristo e em sua obra aponta principalmente para o que?' then 'Segundo a Bíblia, como é descrita a fé salvadora?'
  when 'De forma mais precisa, o que como a fé salvadora descansa em Cristo e em sua obra?' then 'De forma mais precisa, como é descrita a fé salvadora?'
  when 'Qual opção melhor resume que como a fé salvadora descansa em Cristo e em sua obra?' then 'Qual opção resume corretamente a fé salvadora?'
  when 'Qual explicação melhor se encaixa quando como o arrependimento bíblico envolve mudar de mente e direção diante de Deus?' then 'Como é descrito o arrependimento bíblico?'
  when 'De acordo com a Bíblia, como o arrependimento bíblico envolve mudar de mente e direção diante de Deus aponta principalmente para o que?' then 'Segundo a Bíblia, como é descrito o arrependimento bíblico?'
  when 'De forma mais precisa, o que como o arrependimento bíblico envolve mudar de mente e direção diante de Deus?' then 'De forma mais precisa, como é descrito o arrependimento bíblico?'
  when 'Qual opção melhor resume que como o arrependimento bíblico envolve mudar de mente e direção diante de Deus?' then 'Qual opção resume corretamente o arrependimento bíblico?'
  else question_text
end,
explanation = case
  when question_text in (
    'Quem é lembrado por recebeu cartas pastorais para cuidar da igreja?',
    'Que personagem bíblico ficou conhecido por recebeu cartas pastorais para cuidar da igreja?'
  ) and explanation = 'As cartas a Timóteo tratam de doutrina e liderança pastoral.'
    then 'As cartas dirigidas a Timóteo trazem orientações sobre doutrina, liderança e cuidado pastoral.'
  else explanation
end
where language = 'pt-BR'
  and is_active = true
  and review_status = 'approved'
  and question_text in (
    'Quem é lembrado por construiu a arca por ordem de Deus?',
    'Que personagem bíblico ficou conhecido por construiu a arca por ordem de Deus?',
    'Quem é lembrado por foi chamado para deixar sua terra e confiar na promessa divina?',
    'Que personagem bíblico ficou conhecido por foi chamado para deixar sua terra e confiar na promessa divina?',
    'Quem é lembrado por foi usado por Deus para tirar Israel do Egito?',
    'Que personagem bíblico ficou conhecido por foi usado por Deus para tirar Israel do Egito?',
    'Quem é lembrado por foi escolhido como rei e escreveu muitos salmos?',
    'Que personagem bíblico ficou conhecido por foi escolhido como rei e escreveu muitos salmos?',
    'Quem é lembrado por promoveu uma reforma ao ouvir o Livro da Lei?',
    'Que personagem bíblico ficou conhecido por promoveu uma reforma ao ouvir o Livro da Lei?',
    'Quem é lembrado por escreveu o livro de Atos dos Apóstolos?',
    'Que personagem bíblico ficou conhecido por escreveu o livro de Atos dos Apóstolos?',
    'Quem é lembrado por foi o primeiro mártir cristão em Atos?',
    'Que personagem bíblico ficou conhecido por foi o primeiro mártir cristão em Atos?',
    'Quem é lembrado por teve o coração aberto pelo Senhor em Filipos?',
    'Que personagem bíblico ficou conhecido por teve o coração aberto pelo Senhor em Filipos?',
    'Quem é lembrado por foi chamado para ser apóstolo dos gentios?',
    'Que personagem bíblico ficou conhecido por foi chamado para ser apóstolo dos gentios?',
    'Quem é lembrado por recebeu cartas pastorais para cuidar da igreja?',
    'Que personagem bíblico ficou conhecido por recebeu cartas pastorais para cuidar da igreja?',
    'Quem é lembrado por nasceu em Belém para cumprir a promessa messiânica?',
    'Que personagem bíblico ficou conhecido por nasceu em Belém para cumprir a promessa messiânica?',
    'Quem é lembrado por foi batizado por João Batista no rio Jordão?',
    'Que personagem bíblico ficou conhecido por foi batizado por João Batista no rio Jordão?',
    'Quem é lembrado por transformou água em vinho em Caná?',
    'Que personagem bíblico ficou conhecido por transformou água em vinho em Caná?',
    'Quem é lembrado por acalmou a tempestade no mar?',
    'Que personagem bíblico ficou conhecido por acalmou a tempestade no mar?',
    'Quem é lembrado por ressuscitou Lázaro em Betânia?',
    'Que personagem bíblico ficou conhecido por ressuscitou Lázaro em Betânia?',
    'Quem é lembrado por construiu a arca por obediência a Deus?',
    'Que personagem bíblico ficou conhecido por construiu a arca por obediência a Deus?',
    'Quem é lembrado por intercedeu pelo seu povo diante do rei?',
    'Que personagem bíblico ficou conhecido por intercedeu pelo seu povo diante do rei?',
    'Quem é lembrado por permaneceu fiel e orava ao Senhor mesmo sob decreto?',
    'Que personagem bíblico ficou conhecido por permaneceu fiel e orava ao Senhor mesmo sob decreto?',
    'Quem é lembrado por mostrou lealdade a Noemi?',
    'Que personagem bíblico ficou conhecido por mostrou lealdade a Noemi?',
    'Quem é lembrado por foi vendido pelos irmãos e depois governou o Egito?',
    'Que personagem bíblico ficou conhecido por foi vendido pelos irmãos e depois governou o Egito?',
    'Qual verdade bíblica a parábola do bom samaritano ensina amor misericordioso ao próximo?',
    'Qual ensino cristão afirma que a parábola do bom samaritano ensina amor misericordioso ao próximo?',
    'De forma mais precisa, o que a parábola do bom samaritano ensina amor misericordioso ao próximo?',
    'Qual verdade bíblica a parábola do semeador mostra a recepção da Palavra em diferentes corações?',
    'Qual ensino cristão afirma que a parábola do semeador mostra a recepção da Palavra em diferentes corações?',
    'De forma mais precisa, o que a parábola do semeador mostra a recepção da Palavra em diferentes corações?',
    'Qual verdade bíblica a parábola do filho pródigo retrata graça ao arrependido?',
    'Qual ensino cristão afirma que a parábola do filho pródigo retrata graça ao arrependido?',
    'De forma mais precisa, o que a parábola do filho pródigo retrata graça ao arrependido?',
    'Qual verdade bíblica a parábola dos talentos destaca fidelidade com o que Deus confia?',
    'Qual ensino cristão afirma que a parábola dos talentos destaca fidelidade com o que Deus confia?',
    'De forma mais precisa, o que a parábola dos talentos destaca fidelidade com o que Deus confia?',
    'Qual verdade bíblica a parábola do fariseu e do publicano mostra a humildade que busca misericórdia?',
    'Qual ensino cristão afirma que a parábola do fariseu e do publicano mostra a humildade que busca misericórdia?',
    'De forma mais precisa, o que a parábola do fariseu e do publicano mostra a humildade que busca misericórdia?',
    'De acordo com a Bíblia, quantas pessoas há na Trindade aponta principalmente para o que?',
    'De forma mais precisa, o que quantas pessoas há na Trindade?',
    'Qual opção melhor resume que quantas pessoas há na Trindade?',
    'Qual explicação melhor se encaixa quando como Deus declara justo o pecador em Cristo?',
    'De acordo com a Bíblia, como Deus declara justo o pecador em Cristo aponta principalmente para o que?',
    'De forma mais precisa, o que como Deus declara justo o pecador em Cristo?',
    'Qual opção melhor resume que como Deus declara justo o pecador em Cristo?',
    'Qual explicação melhor se encaixa quando como a santificação transforma a vida do crente?',
    'De acordo com a Bíblia, como a santificação transforma a vida do crente aponta principalmente para o que?',
    'De forma mais precisa, o que como a santificação transforma a vida do crente?',
    'Qual opção melhor resume que como a santificação transforma a vida do crente?',
    'Qual explicação melhor se encaixa quando como a regeneração é obra do Espírito Santo que dá nova vida?',
    'De acordo com a Bíblia, como a regeneração é obra do Espírito Santo que dá nova vida aponta principalmente para o que?',
    'De forma mais precisa, o que como a regeneração é obra do Espírito Santo que dá nova vida?',
    'Qual opção melhor resume que como a regeneração é obra do Espírito Santo que dá nova vida?',
    'Qual explicação melhor se encaixa quando como a perseverança dos santos depende do cuidado preservador de Deus?',
    'De acordo com a Bíblia, como a perseverança dos santos depende do cuidado preservador de Deus aponta principalmente para o que?',
    'De forma mais precisa, o que como a perseverança dos santos depende do cuidado preservador de Deus?',
    'Qual opção melhor resume que como a perseverança dos santos depende do cuidado preservador de Deus?',
    'Qual explicação melhor se encaixa quando como a salvação é dom imerecido de Deus?',
    'De acordo com a Bíblia, como a salvação é dom imerecido de Deus aponta principalmente para o que?',
    'De forma mais precisa, o que como a salvação é dom imerecido de Deus?',
    'Qual opção melhor resume que como a salvação é dom imerecido de Deus?',
    'Qual explicação melhor se encaixa quando como a fé salvadora descansa em Cristo e em sua obra?',
    'De acordo com a Bíblia, como a fé salvadora descansa em Cristo e em sua obra aponta principalmente para o que?',
    'De forma mais precisa, o que como a fé salvadora descansa em Cristo e em sua obra?',
    'Qual opção melhor resume que como a fé salvadora descansa em Cristo e em sua obra?',
    'Qual explicação melhor se encaixa quando como o arrependimento bíblico envolve mudar de mente e direção diante de Deus?',
    'De acordo com a Bíblia, como o arrependimento bíblico envolve mudar de mente e direção diante de Deus aponta principalmente para o que?',
    'De forma mais precisa, o que como o arrependimento bíblico envolve mudar de mente e direção diante de Deus?',
    'Qual opção melhor resume que como o arrependimento bíblico envolve mudar de mente e direção diante de Deus?'
  );

commit;

-- Validacao depois
-- select id, language, category, difficulty, level, question_text, explanation, bible_reference
-- from public.questions
-- where language = 'pt-BR'
--   and question_text ilike '%por recebeu%';
--
-- select id, language, category, difficulty, level, question_text, explanation, bible_reference
-- from public.questions
-- where language = 'pt-BR'
--   and question_text = 'Quem recebeu cartas pastorais com orientações para cuidar da igreja?';
